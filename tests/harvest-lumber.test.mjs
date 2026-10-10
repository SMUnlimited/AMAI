// Run: node --test --test-reporter=spec tests/harvest-lumber.test.mjs
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { lumberGame } from './helpers/lumber-game.mjs';

describe('Lumber shortages release flexible gold workers', () => {
  it('Given five Orc miners and low lumber, when harvesting is checked repeatedly, then two peons stay available for lumber', () => {
    const game = lumberGame('orc');

    game.checkHarvest();
    game.checkHarvest();

    assert.equal(game.state.harvestgrp.size, 3);
    assert.equal(game.state.harvest_available_peons.size, 2);
    assert.equal(game.orders.filter(o => o.order === 'stop').length, 2);
    assert.equal(game.orders.filter(o => o.order === 'harvest').length, 0);
  });

  it('Given five loaded wisps and low lumber, when harvesting is checked, then two wisps leave the mine', () => {
    const game = lumberGame('elf');

    game.checkHarvest();

    assert.equal(game.workers.filter(u => u.loaded).length, 3);
    assert.equal(game.state.harvestgrp.size, 3);
    assert.equal(game.orders.filter(o => o.order === 'unload').length, 2);
  });

  it('Given released wisps, when lumber recovers, then the mine returns to five workers', () => {
    const game = lumberGame('elf');
    game.checkHarvest();

    game.state.wood = 200;
    game.checkHarvest();

    assert.equal(game.workers.filter(u => u.loaded).length, 5);
    assert.equal(game.state.harvestgrp.size, 5);
  });

  it('Given released Orc peons, when lumber recovers, then the mine returns to five workers', () => {
    const game = lumberGame('orc');
    game.checkHarvest();

    game.state.wood = 200;
    game.checkHarvest();

    assert.equal(game.state.harvestgrp.size, 5);
    assert.equal(game.orders.filter(o => o.order === 'harvest').length, 2);
  });

  it('Given low gold as well as low lumber, when harvesting is checked, then all five miners remain', () => {
    const game = lumberGame('orc', { gold: 300, wood: 0 });

    game.checkHarvest();

    assert.equal(game.state.harvestgrp.size, 5);
    assert.equal(game.orders.length, 0);
  });

  it('Given Undead acolytes and low lumber, when harvesting is checked, then workers unable to chop trees keep mining', () => {
    const game = lumberGame('undead');

    game.checkHarvest();

    assert.equal(game.state.harvestgrp.size, 5);
    assert.equal(game.orders.length, 0);
  });

  it('Given a mine with vacancies during a lumber shortage, when harvesting is checked, then only three Orc miners are assigned', () => {
    const game = lumberGame('orc');
    game.state.harvest_assignments[0].clear();
    game.workers.forEach(u => { u.order = 'stop'; });

    game.checkHarvest();

    assert.equal(game.state.harvestgrp.size, 3);
    assert.equal(game.orders.filter(o => o.order === 'harvest').length, 3);
  });

  it('Given a reserved Orc worker during a shortage, when harvesting is checked, then its job is not interrupted', () => {
    const game = lumberGame('orc');
    const builder = game.workers[4];
    builder.reserved = true;
    builder.order = 'construction';

    game.checkHarvest();

    assert.equal(builder.order, 'construction');
    assert.equal(game.orders.some(o => o.unit === builder), false);
    assert.equal(game.state.harvestgrp.size, 3);
  });

  it('Given four wisps and no food space during a shortage, when harvesting is checked, then the food builder is still freed', () => {
    const game = lumberGame('elf');
    game.workers.pop();
    game.state.TownCount = game.state.TownCountDone = () => 4;
    game.state.FoodSpace = () => 0;

    game.checkHarvest();

    assert.equal(game.workers.filter(u => u.loaded).length, 2);
    assert.equal(game.state.harvestgrp.size, 2);
  });
});
