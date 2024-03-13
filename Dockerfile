ARG PROVIDER_VERSION
ARG TERRAFORM_VERSION

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform
FROM xpkg.upbound.io/upbound/provider-terraform:v${PROVIDER_VERSION}

COPY --from=terraform /bin/terraform /usr/local/bin/terraform
