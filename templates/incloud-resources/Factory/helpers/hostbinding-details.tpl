{{- define "netguard.web-resources.factory.manifets.hostbinding-details" -}}
{{- $key          := (default "hostbinding-details" .key) -}}
{{- $instanceMode := (default "false" .instanceMode) -}}
{{- $nsAliasMode  := (default "false" .nsAliasMode) -}}

{{- $pathIndexBasePrefix  := "{1}" -}}
{{- $pathIndexCluster     := "{2}" -}}
{{- $pathIndexNamespace   := "{3}" -}}
{{- $pathIndexApiGroup    := "{6}" -}}
{{- $pathIndexApiVersion  := "{7}" -}}
{{- $pathIndexPlural      := "{8}" -}}
{{- $pathIndexResName     := "{9}" -}}

{{- if eq ($instanceMode | toString ) "true" -}}
{{- $pathIndexApiGroup    = "{7}" -}}
{{- $pathIndexApiVersion  = "{8}" -}}
{{- $pathIndexPlural      = "{9}" -}}
{{- $pathIndexResName     = "{10}" -}}
{{- end -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: {{ $key }}
spec:
  key: {{ $key }}
  sidebarTags:
    - {{ $key }}
  withScrollableMainContentCard: true
  urlsToFetch:

    - cluster: "{{ $pathIndexCluster }}"
      apiGroup: "{{ $pathIndexApiGroup }}"
      apiVersion: "{{ $pathIndexApiVersion }}"
      namespace: "{{ $pathIndexNamespace }}"
      plural: "{{ $pathIndexPlural }}"
      fieldSelector: "metadata.name={{ $pathIndexResName }}"

    {{ if eq ($nsAliasMode | toString) "true" }}
    - cluster: "{{ $pathIndexCluster }}"
      apiVersion: "v1"
      plural: "namespaces"
    {{ end }}

  data:
    - type: antdFlex
      data:
        id: header-row
        align: center
        gap: 6
        style:
          marginBottom: 24px
      children:
        - type: ResourceBadge
          data:
            id: ag-kind
            value: '{reqsJsonPath[0][".items.0.kind"]["-"]}'
            style:
              fontSize: 20px
        - type: parsedText
          data:
            id: ag-name
            style:
              fontSize: 20px
              lineHeight: 24px
            text: '{reqsJsonPath[0][".items.0.metadata.name"]["-"]}'
            
    - type: antdTabs
      data:
        id: ag-tabs
        defaultActiveKey: details
        items:
          - key: details
            label: Details
            children:
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  - data:
                      id: details-title
                      style:
                        fontSize: 20
                        marginBottom: 12px
                        fontWeight: bold
                      text: '{reqsJsonPath[0][".items.0.kind"]["-"]} Details'
                    type: parsedText

                  - data:
                      $space: 16
                      id: details-spacer
                    type: Spacer

                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      - type: antdCol
                        data:
                          id: col-left
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: meta-block-left
                              gap: 24
                              vertical: true
                            children:
                              - type: antdFlex
                                data:
                                  id: name-block
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: name-label
                                      strong: true
                                      text: Name
                                  - type: parsedText
                                    data:
                                      id: name-value
                                      text: '{reqsJsonPath[0][".items.0.metadata.name"]["-"]}'

                              - type: antdFlex
                                data:
                                  id: ns-block
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: ns-label
                                      strong: true
                                      text: Namespace
                                  - type: antdFlex
                                    data:
                                      id: ns-link-row
                                      align: center
                                      direction: row
                                      gap: 6
                                    children:
                                      - type: ResourceBadge
                                        data:
                                          id: ns-badge
                                          value: Namespace
                                      - type: antdLink
                                        data:
                                          id: ns-link
                                          href: "/{{ $pathIndexBasePrefix }}/{{ $pathIndexCluster }}/factory/namespace-details/v1/namespaces/{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}"
                                        {{ if eq ($nsAliasMode | toString) "true" }}
                                          text: |
                                            {reqsJsonPath[1][".items[?(@.metadata.name=="{{ $pathIndexNamespace }}")].metadata.labels.alias"]["-"]}
                                        {{ else }}
                                          text: '{reqsJsonPath[0][".items.0.metadata.namespace"]["-"]}'
                                        {{ end }}

                              - type: antdFlex
                                data:
                                  id: labels
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      text: Labels
                                      strong: true
                                  - type: Labels
                                    data:
                                      containerStyle:
                                        marginTop: -30px
                                      editModalWidth: 650
                                      endpoint: "/api/clusters/{{ $pathIndexCluster }}/k8s/apis/netguard.sgroups.io/v1beta1/namespaces/{{ $pathIndexNamespace }}/hostbindings/{{ $pathIndexResName }}"
                                      id: labels-editor
                                      inputLabel: ""
                                      jsonPathToLabels: .items.0.metadata.labels
                                      maxEditTagTextLength: 35
                                      modalDescriptionText: ""
                                      modalTitle: Edit labels
                                      notificationSuccessMessage: Updated successfully
                                      notificationSuccessMessageDescription: Labels have been updated
                                      paddingContainerEnd: 24px
                                      pathToValue: /metadata/labels
                                      reqIndex: 0
                                      selectProps:
                                        maxTagTextLength: 35
                                
                              - type: antdFlex
                                data:
                                  gap: 4
                                  id: ds-annotations
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: annotations
                                      strong: true
                                      text: Annotations
                                    
                                  - type: Annotations
                                    data:
                                      cols:
                                      - 11
                                      - 11
                                      - 2
                                      editModalWidth: 800px
                                      endpoint: "/api/clusters/{{ $pathIndexCluster }}/k8s/apis/netguard.sgroups.io/v1beta1/namespaces/{{ $pathIndexNamespace }}/hostbindings/{{ $pathIndexResName }}"
                                      errorText: 0 Annotations
                                      id: annotations
                                      inputLabel: ""
                                      jsonPathToObj: .items.0.metadata.annotations
                                      modalDescriptionText: ""
                                      modalTitle: Edit annotations
                                      notificationSuccessMessage: Updated successfully
                                      notificationSuccessMessageDescription: Annotations have been
                                        updated
                                      pathToValue: /metadata/annotations
                                      reqIndex: 0
                                      text: ~counter~ Annotations

                              - type: antdFlex
                                data:
                                  id: created-block
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: created-label
                                      strong: true
                                      text: Created
                                  - type: antdFlex
                                    data:
                                      id: time-icon
                                      align: center
                                      gap: 6
                                    children:
                                      - type: antdText
                                        data:
                                          id: time-icon
                                          text: "🌐"
                                      - type: parsedText
                                        data:
                                          id: created-value
                                          formatter: timestamp
                                          text: '{reqsJsonPath[0][".items.0.metadata.creationTimestamp"]["-"]}'

                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: spec-block
                              gap: 24
                              vertical: true
                            children:
                              - type: antdFlex
                                data:
                                  id: ns-block
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: ns-label
                                      strong: true
                                      text: Host Ref
                                  - type: antdFlex
                                    data:
                                      id: ns-link-row
                                      align: center
                                      direction: row
                                      gap: 6
                                    children:
                                      - type: ResourceBadge
                                        data:
                                          id: ns-badge
                                          value: "{reqsJsonPath[0]['.items.0.spec.hostRef.kind']['-']}"
                                      - type: antdLink
                                        data:
                                          id: ns-link
                                          href: "/{{ $pathIndexBasePrefix }}/{{ $pathIndexCluster }}/{reqsJsonPath[0]['.items.0.spec.hostRef.namespace']['-']}/factory/host-details/netguard.sgroups.io/v1beta1/hosts/{reqsJsonPath[0]['.items.0.spec.hostRef.name']['-']}"
                                        {{ if eq ($nsAliasMode | toString) "true" }}
                                          text: |
                                            {reqsJsonPath[1]['.items[?(@.metadata.name=="{reqsJsonPath[0][".items.0.spec.hostRef.namespace"]}")].metadata.labels.alias']["-"]}/{reqsJsonPath[0][".items.0.spec.hostRef.name"]["-"]}
                                        {{ else }}
                                          text: '{reqsJsonPath[0][".items.0.spec.hostRef.namespace"]["-"]}/{reqsJsonPath[0][".items.0.spec.hostRef.name"]["-"]}'
                                        {{ end }}

                              - type: antdFlex
                                data:
                                  id: ns-block
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      id: ns-label
                                      strong: true
                                      text: AddressGroup Ref
                                  - type: antdFlex
                                    data:
                                      id: ns-link-row
                                      align: center
                                      direction: row
                                      gap: 6
                                    children:
                                      - type: ResourceBadge
                                        data:
                                          id: ns-badge
                                          value: "{reqsJsonPath[0]['.items.0.spec.addressGroupRef.kind']['-']}"
                                      - type: antdLink
                                        data:
                                          id: ns-link
                                          href: "/{{ $pathIndexBasePrefix }}/{{ $pathIndexCluster }}/{reqsJsonPath[0]['.items.0.spec.addressGroupRef.namespace']['-']}/factory/addressgroup-details/netguard.sgroups.io/v1beta1/addressgroups/{reqsJsonPath[0]['.items.0.spec.addressGroupRef.name']['-']}"
                                        {{ if eq ($nsAliasMode | toString) "true" }}
                                          text: |
                                            {reqsJsonPath[1]['.items[?(@.metadata.name=="{reqsJsonPath[0][".items.0.spec.addressGroupRef.namespace"]}")].metadata.labels.alias']["-"]}/{reqsJsonPath[0][".items.0.spec.addressGroupRef.name"]["-"]}
                                        {{ else }}
                                          text: '{reqsJsonPath[0][".items.0.spec.addressGroupRef.namespace"]["-"]}/{reqsJsonPath[0][".items.0.spec.addressGroupRef.name"]["-"]}'
                                        {{ end }}

                  - data:
                      $space: 16
                      id: details-spacer
                    type: Spacer

                  - type: VisibilityContainer
                    data:
                      id: conditions-container
                      style:
                        margin: 0
                        padding: 0
                      value: "{reqsJsonPath[0]['.items.0.status.conditions']['-']}"
                    children:
                    - data:
                        id: conditions-title
                        strong: true
                        style:
                          fontSize: 22px
                          marginBottom: 16px
                        text: Conditions
                      type: antdText
                    - data:
                        baseprefix: /{{ $pathIndexBasePrefix }}
                        cluster: '{{ $pathIndexCluster }}'
                        customizationId: factory-status-conditions
                        id: conditions-table
                        pathToItems: .items.0.status.conditions
                        withoutControls: true
                        k8sResourceToFetch: 
                          apiGroup: "netguard.sgroups.io"
                          apiVersion: "v1beta1"
                          plural: "hostbindings"
                          namespace: "{{ $pathIndexNamespace }}"
                        fieldSelector:
                          metadata.name: "{{ $pathIndexResName }}"
                      type: EnrichedTable

          - key: yaml
            label: YAML
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: '{{ $pathIndexCluster }}'
                  type: apis
                  isNameSpaced: true
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  plural: hostbindings
                  pathToData: .items.0
                  forcedKind: HostBinding
                  apiGroup: netguard.sgroups.io
                  apiVersion: v1beta1
{{ end }}
