# Luckdragon

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

## Usage

This docker cloud stack contains two services:

- **luckdragon**: Use Docker Cloud API to fetch your proxies services and dynamically write nginx conf on `/etc/nginx/conf.d/luckdragon.conf`.
- **nginx**: Basic nginx docker image. It mounts volumes from `luckdragon`.

A service will be visible for luckdragon if it contains these three environment variables:

- **LUCKDRAGON_SERVER_NAME**: Proxy's server name. e.g. `games.beagleknight.com`
- **LUCKDRAGON_UPSTREAM_NAME**: Upstream's identifier. e.g `games`
- **LUCKDRAGON_PROXY_PORT**: Application's port. e.g. `80`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beagleknight/luckdragon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
