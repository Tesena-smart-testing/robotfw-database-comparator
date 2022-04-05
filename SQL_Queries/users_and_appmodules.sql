select FirstName, LastName, Email, r.name as 'RoleName', AppModuleName
from [dbo].[Users] u join [dbo].[UserAppModuleRel] ua on u.userID = ua.userID
join [dbo].[Roles] r on u.roleID = r.roleID
join [dbo].[AppModules] a on ua.appmoduleid = a.appmoduleid
where u.Active=1