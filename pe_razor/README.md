## Installation

1. Install the PE agent.
2. Run `puppet apply -e 'include pe_razor'`

The `pe_razor` module performs a full install of Razor on any node that is
classified with it. This includes installing a PostgreSQL database, all the
prerequisites for the Razor server and the server code itself, and the
Razor microkernel.

You will still need to configure your PXE infrastructure, i.e. your DHCP
and TFTP server separately; please follow the Razor documentation for
details about that.

### Parameters

The `pe_razor` module takes the following parameters:

* `dbpassword`: the database password to use for Razor's database, defaults
  to `razor`
* `pe_tarball_base_url`: the location of the Puppet Enterprise tarball
* `microkernel_url`: the URL from which to fetch the Microkernel
* `server_http_port`: The port for HTTP communications with Razor server,
  defaults to 8150
* `server_https_port`: The port for HTTPS communications with Razor server,
  defaults to 8151
