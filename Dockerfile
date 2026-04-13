ARG PROVIDER_VERSION=1.1.2
ARG TERRAFORM_VERSION=1.11.3
ARG KUBECTL_VERSION=1.35.3

FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform
FROM alpine/kubectl:${KUBECTL_VERSION} AS kubectl
FROM xpkg.upbound.io/upbound/provider-terraform:v${PROVIDER_VERSION} AS provider

FROM alpine:3.23.3

# Add Tini
ARG TARGETARCH
ENV TINI_VERSION=v0.19.0
ADD --chmod=555 https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-${TARGETARCH} /sbin/tini

RUN apk --no-cache add -u zlib ca-certificates bash git curl

ENV TF_IN_AUTOMATION=1
ENV TF_PLUGIN_CACHE_DIR=/tf/plugin-cache

ADD .gitconfig .gitconfig

# As of Crossplane v1.3.0 provider controllers run as UID 2000.
# https://github.com/crossplane/crossplane/blob/v1.3.0/internal/controller/pkg/revision/deployment.go#L32
RUN mkdir -p ${TF_PLUGIN_CACHE_DIR} && chown -R 2000 /tf

COPY --from=provider /usr/local/bin/crossplane-terraform-provider /usr/local/bin/crossplane-terraform-provider
COPY --from=provider /package.yaml /package.yaml
COPY --from=provider /models/ /models/
COPY --from=terraform /bin/terraform /usr/local/bin/terraform
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/

USER 65532

ENTRYPOINT ["tini", "--", "crossplane-terraform-provider"]
