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
