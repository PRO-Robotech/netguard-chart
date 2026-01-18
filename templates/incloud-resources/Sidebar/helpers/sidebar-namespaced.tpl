# return [] if sidebebar items are empty
{{ define "netguard.web-resources.sidebar.menu.items.namespaced" }}
{{ if (include "netguard.web-resources.sidebar.menu.items.namespaced-items" . | trim) }}
{{ include "netguard.web-resources.sidebar.menu.items.namespaced-items" . }}
{{ else }}
[]
{{ end }}
{{ end }}

{{ define "netguard.web-resources.sidebar.menu.items.namespaced-items" }}
{{ $webResources  := .Values.webResources }}
{{ $sidebars      := $webResources.sidebars.namespaced }}
{{ $projRes       := $webResources.projectResource }}
{{ $instRes       := $webResources.instanceResource }}

{{ with $sidebars.home }}
  {{ if .enabled }}
- children:
    {{ if .items.search }}
    - key: search
      label: Search
      link: /openapi-ui/{cluster}/search
    {{ end }}
    {{ if .items.projects }}
    - key: projects
      label: Projects
      link: /{1}/{cluster}/api-table/{{ $projRes.apiGroup }}/{{ $projRes.apiVersion }}/{{ $projRes.resourceName }}
    {{ end }}
    {{ if .items.instances }}
    - key: instances
      label: Instances
      link: /{1}/{cluster}/{namespace}/api-table/{{ $instRes.apiGroup }}/{{ $instRes.apiVersion }}/{{ $instRes.resourceName }}
    {{ end }}
  key: home
  label: Home
  {{ end }}
{{ end }}

{{- if $sidebars.customItems -}}
  {{- range $sidebars.customItems }}
{{ $sidebars.customItems | toYaml }}
  {{- end }}
{{- end -}}


{{ with $sidebars.hbf }}
  {{ if .enabled }}
- key: hbf
  label: HBF
  children:
    {{ if .items.hosts }}
    - key: hbf-hosts
      label: Hosts
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/hosts?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.networks }}
    - key: hbf-networks
      label: Networks
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/networks?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroups }}
    - key: hbf-addressgroups
      label: AddressGroups
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/addressgroups?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.services }}
    - key: hbf-services
      label: Services
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/services?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.svcsvcrules }}
    - key: hbf-svcsvcrules
      label: SvcSvcRules
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/svcsvcrules?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.svcfqdnrules }}
    - key: hbf-svcfqdnrules
      label: SvcFqdnRules
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/svcfqdnrules?resources=/v1/namespaces"
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  {{ end }}
{{ end }}

{{ with $sidebars.hbfSystem }}
  {{ if .enabled }}
- key: hbfSystem
  label: HBF System
  children:
    {{ if .items.hostbindings }}
    - key: hbf-hostbindings
      label: HostBindings
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/hostbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.networkbindings }}
    - key: hbf-networkbindings
      label: NetworkBindings
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/networkbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroupbindings }}
    - key: hbf-addressgroupbindings
      label: AddressGroupBindings
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/addressgroupbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroupportmappings }}
    - key: hbf-addressgroupportmappings
      label: AddressGroupPortMappings
      link: "/{1}/{cluster}/{namespace}/api-table/netguard.sgroups.io/v1beta1/addressgroupportmappings?resources=/v1/namespaces"
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  {{ end }}
{{ end }}

{{ end }}
