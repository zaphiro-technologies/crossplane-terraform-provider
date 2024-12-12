ARG PROVIDER_VERSION
ARG TERRAFORM_VERSION
ARG KUBECTL_VERSION

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform
FROM bitnami/kubectl:${KUBECTL_VERSION} as kubectl

FROM xpkg.upbound.io/upbound/provider-terraform:v${PROVIDER_VERSION}
COPY --from=terraform /bin/terraform /usr/local/bin/terraform
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/
