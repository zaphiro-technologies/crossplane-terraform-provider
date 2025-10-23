ARG PROVIDER_VERSION
ARG TERRAFORM_VERSION
ARG KUBECTL_VERSION

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform
FROM alpine/kubectl:${KUBECTL_VERSION} as kubectl

FROM xpkg.upbound.io/upbound/provider-terraform:v${PROVIDER_VERSION}

# Add Tini
ARG TARGETARCH
ENV TINI_VERSION v0.19.0
ADD --chmod=555 https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-${TARGETARCH} /sbin/tini

COPY --from=terraform /bin/terraform /usr/local/bin/terraform
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/
ENTRYPOINT ["tini", "--", "crossplane-terraform-provider"]
