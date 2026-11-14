// Shared Set-backed group operations. Enumeration and unit policies are game-specific.
export function groupNatives(activeGroups) {
  return {
    CreateGroup() {
      const group = new Set();
      activeGroups?.add(group);
      return group;
    },
    DestroyGroup: group => { activeGroups?.delete(group); },
    GroupClear: group => group.clear(),
    GroupAddUnit: (group, unit) => group.add(unit),
    GroupRemoveUnit: (group, unit) => group.delete(unit),
    FirstOfGroup: group => group.values().next().value ?? null,
    IsUnitInGroup: (unit, group) => group.has(unit),
  };
}

// Object keys stand in for native handle IDs; each game gets fresh tables.
export function hashtableNatives() {
  return {
    GetHandleId: handle => handle,
    HaveSavedReal: (table, parent, child) => table.get(parent)?.has(child) ?? false,
    LoadReal: (table, parent, child) => table.get(parent)?.get(child) ?? 0,
    SaveReal(table, parent, child, value) {
      if (!table.has(parent)) table.set(parent, new Map());
      table.get(parent).set(child, value);
    },
    FlushChildHashtable: (table, parent) => table.delete(parent),
    FlushParentHashtable: table => table.clear(),
  };
}
