// 角色类型映射
const roleTypeMap: Record<string, string> = {
    main: '主角',
    supporting: '配角',
    minor: '次要'
  };

/**
 * 获取角色类型的中文名称
 * @param roleType - 角色类型：main(主角) | supporting(配角) | minor(次要)
 * @returns 角色类型的中文名称
 */
export function getRoleTypeName(roleType: string): string {
  return roleTypeMap[roleType] || roleType;
}