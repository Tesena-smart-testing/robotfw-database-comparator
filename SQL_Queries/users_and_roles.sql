SELECT u.firstname, u.lastname, u.email, u.active, r.rolename FROM Users u JOIN Roles r ON u.roleId = r.ID