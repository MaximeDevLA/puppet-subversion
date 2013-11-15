# Subversion

Released 20110608 - Craig Dunn - GPLv2  
Patched to include --no-auth-cache option 20121109 - Michael Hall <pdxmph@gmail.com>
Patched to checkout and then export (it removes .svn directories) 20131114 - Maxime Devalland

Definition: svn::checkout

Check out a subversion repository to a working directory

## Parameters:
`$repopath` 			- Path to the repository  
`$workingdir`			- Local working directory to checkout to  
`$ensure` (optional)		- Set to updated to ensure latest svn update  
`$host` (optional)		- Subversion server hostname  
`$method` (optional)		- Protocol to use (http,https,svn..etc)  
`$svnuser` (optional) 	- Username to connect with  
`$password` (optional)	- Password to connect with  
`$revision` (optional)	- Revision to check out  
`$trustcert` (optional)	- Use --trust-server-cert  
`$noauthcache` (optional) - Use --no-auth-cache
`$forceoverwrite (optional)  - Overwrite existing directories and files on exportche


## Sample usage
	subversion::checkout { "application/trunk": 
		repopath	=> "/app/trunk",
		workingdir	=> "/var/src/app",
		tmpdir		=> "/tmp/svn-myrepo",
		host		=> "subversion.local",
		method		=> "http",
		svnuser		=> "application",
		password	=> "kjhsdfkj",
		require		=> File["/var/src/app"],
	}
	
