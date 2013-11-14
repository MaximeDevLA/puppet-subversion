# Class: subversion
#
# Manage subversion checkouts
class subversion {

	package { "subversion":
		ensure		=> latest,
	}

	$svnflags = "--non-interactive"

# Definition: svn::checkout
#
# Check out a subversion repository to a working directory
#
# Parameters:
#   $repopath 				- Path to the repository
#   $workingdir				- Local destination directory
#   $tmpdir					- Local temporary directory to checkout to
#   $ensure (optional)		- Set to updated to ensure latest svn update
#   $host (optional)		- Subversion server hostname
#   $method (optional)		- Protocol to use (http,https,svn..etc)
#   $svnuser (optional) 	- Username to connect with
#   $password (optional)	- Password to connect with
#   $revision (optional)	- Revision to check out
#   $trustcert (optional)	- Use --trust-server-cert
#   $noauthcache (optional)     - Use --no-auth-cache
#   $forceoverwrite (optional)  - Overwrite existing directories and files
#
#
# Sample usage
#	subversion::checkout { "application/trunk":
#		repopath	=> "/app/trunk",
#		workingdir	=> "/var/src/app",
#		host		=> "subversion.local",
#		method		=> "http",
#		svnuser		=> "application",
#		password	=> "kjhsdfkj",
#		require		=> File["/var/src/app"],
#	}
#
	define checkout (
			$repopath,
			$workingdir,
			$tmpdir,
			$ensure		= "exists",
			$host		= false,
			$method		= false,
			$svnuser	= false,
			$revision	= "HEAD",
			$password	= false,
			$trustcert	= false,
			$noauthcache    = false,
			$forceoverwrite = false,
	) {



		$urlmethod = $method ? {
				false 	=> "",
				default => "$method://"
				}

		$optuser = $svnuser ? {
				false	=> "",
				default	=> "--username $svnuser",
		}

		$urlhost = $host ? {
				false	=> "",
				default	=> "$host"
		}

		$optpassword = $password ? {
				false	=> "",
				default	=> "--password $password"
		}

		$opttrustcert = $trustcert ? {
				false	=> "",
				default => "--trust-server-cert"
		}

        $optnoauthcache = $noauthcache ? {
                false => "",
                default => "--no-auth-cache"
        }

		$optforceoverwrite = $forceoverwrite ? {
                false => "",
                default => "--force"
        }

		$svnurl = "${urlmethod}${urlhost}${repopath}"
		Exec { path	=> "/bin:/usr/bin:/usr/local/bin" }


		exec { "$svnurl:$tmpdir:checkout":
			cwd	=> $tmpdir,
			command	=> "svn checkout $svnflags $optnoauthcache $optuser $optpassword $opttrustcert -r$revision $optforceoverwrite $svnurl $tmpdir",
			creates	=> "$tmpdir/.svn",
			require	=> Package["subversion"],
		}

		exec { "$svnurl:$workingdir:export":
			cwd	=> $workingdir,
			command	=> "svn export $optuser $optpassword $tmpdir $workingdir",
			require	=> Package["subversion"],
		}


		if ( $ensure == "updated" ) {
			exec { "$svnurl:$workingdir:update":
				cwd	=> "$workingdir",
				command => "svn update $svnflags $optnoauthcache $optuser $optpassword $opttrustcert -r$revision",
				require	=> Package["subversion"],
			}
		}


	}

}
