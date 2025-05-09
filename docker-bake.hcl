variable "VERSION" {
  # renovate: datasource=custom.ts3server depName=ts3-server
  default = "3.13.7"
}

group "default" {
  targets = ["default"]
}

target "default" {
  tags = ["quay.io/seiferma/ts3server:${VERSION}", "quay.io/seiferma/ts3server:latest"]
  args = {
    TS3_VERSION = "${VERSION}"
  }
}
