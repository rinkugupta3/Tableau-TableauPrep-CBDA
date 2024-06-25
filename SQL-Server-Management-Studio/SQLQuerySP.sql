Create Database JustToCheck

Execute sp_renamedb 'JustToCheck', 'JustToCheckRename'

Execute sp_dropdb 'JustToCheckRename'

Execute sp_deletedb 'JustToCheckRename'