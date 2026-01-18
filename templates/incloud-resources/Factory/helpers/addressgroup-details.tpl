{{- define "netguard.web-resources.factory.manifets.addressgroup-details" -}}
{{- $key          := (default "addressgroup-details" .key) -}}
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

    - cluster: "{{ $pathIndexCluster }}"
      apiGroup: "netguard.sgroups.io"
      apiVersion: "v1beta1"
      namespace: "{{ $pathIndexNamespace }}"
      plural: "networks"
      fieldSelector: "status.addressGroupRef.name={{ $pathIndexResName }}"

    - cluster: "{{ $pathIndexCluster }}"
      apiGroup: "netguard.sgroups.io"
      apiVersion: "v1beta1"
      namespace: "{{ $pathIndexNamespace }}"
      plural: "hosts"
      fieldSelector: "status.addressGroupRef.name={{ $pathIndexResName }}"

    {{ if eq ($nsAliasMode | toString) "true" }}
    - cluster: "{{ $pathIndexCluster }}"
      apiVersion: "v1"
      plural: "namespaces"
      fieldSelector: "metadata.name={{ $pathIndexNamespace }}"
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
                                          text: '{reqsJsonPath[3][".items.0.metadata.labels.alias"]["-"]}'
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
                                      endpoint: "/api/clusters/{{ $pathIndexCluster }}/k8s/apis/netguard.sgroups.io/v1beta1/namespaces/{{ $pathIndexNamespace }}/addressgroups/{{ $pathIndexResName }}"
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
                                      endpoint: "/api/clusters/{{ $pathIndexCluster }}/k8s/apis/netguard.sgroups.io/v1beta1/namespaces/{{ $pathIndexNamespace }}/addressgroups/{{ $pathIndexResName }}"
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
                                  id: sgroup-name
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      text: SGroup Name
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: trace-value
                                      text: '{reqsJsonPath[0][".items.0.status.addressGroupName"]["-"]}'


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
                                  id: default-action
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      text: Default Action
                                      strong: true
                                  - type: TogglerSegmented
                                    data:
                                      id: toggler-segmented
                                      reqIndex: 0
                                      jsonPathToValue: ".items.0.spec.defaultAction"
                                      notificationSuccessMessage: Updated successfully
                                      notificationSuccessMessageDescription: String/exist toggler has been updated
                                      notificationErrorMessage: Update error
                                      notificationErrorMessageDescription: String/exist toggler has not been updated
                                      endpoint: /api/clusters/{{ $pathIndexCluster }}/k8s/apis/{reqsJsonPath[0]['.items.0.apiVersion']['-']}/namespaces/{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}/addressgroups/{reqsJsonPath[0]['.items.0.metadata.name']['-']}
                                      pathToValue: /spec/defaultAction
                                      possibleValues:
                                        - ACCEPT
                                        - DROP
                                      valuesMap:
                                        - value: ACCEPT
                                          renderedValue: ACCEPT
                                        - value: DROP
                                          renderedValue: DROP

                              - type: antdFlex
                                data:
                                  id: trace
                                  gap: 4
                                  vertical: true
                                children:
                                  - type: antdText
                                    data:
                                      text: Trace
                                      strong: true
                                  - type: Toggler
                                    data:
                                      id: toggler-trace-boolean
                                      reqIndex: 0
                                      jsonPathToValue: ".items.0.spec.trace"
                                      criteria:
                                        type: "forSuccess"
                                        operator: "equals"
                                        valueToCompare: "true"
                                      notificationSuccessMessage: Updated successfully
                                      notificationSuccessMessageDescription: Boolean toggler has been updated
                                      notificationErrorMessage: Update error
                                      notificationErrorMessageDescription: Boolean toggler has not been updated
                                      endpoint: /api/clusters/{{ $pathIndexCluster }}/k8s/apis/{reqsJsonPath[0]['.items.0.apiVersion']['-']}/namespaces/{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}/addressgroups/{reqsJsonPath[0]['.items.0.metadata.name']['-']}
                                      pathToValue: /spec/trace
                                      valueToSubmit:
                                        onValue: true
                                        offValue: false

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
                        baseprefix: /openapi-ui # TODO: template baseprefix value
                        cluster: '{{ $pathIndexCluster }}'
                        customizationId: factory-status-conditions
                        id: conditions-table
                        pathToItems: .items.0.status.conditions
                        withoutControls: true
                        k8sResourceToFetch: 
                          apiGroup: "netguard.sgroups.io"
                          apiVersion: "v1beta1"
                          plural: "addressgroups"
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
                  plural: addressgroups
                  pathToData: .items.0
                  forcedKind: AddressGroup
                  apiGroup: netguard.sgroups.io
                  apiVersion: v1beta1

          - key: network-binding
            label: Network Binding
            children:
              - data:
                  baseprefix: /openapi-ui # TODO: template baseprefix value
                  cluster: "{{ $pathIndexCluster }}"
                  customizationId: stock-namespace-/netguard.sgroups.io/v1beta1/networkbindings-ag
                  id: conditions-table
                  pathToItems: .items
                  withoutControls: false
                  namespace: "{{ $pathIndexNamespace }}"
                  isNamespaced: true
                  dataForControls:
                    plural: networkbindings
                    apiVersion: v1beta1
                    apiGroup: netguard.sgroups.io
                  fieldSelector:
                    spec.addressGroupRef.name: "{{ $pathIndexResName }}"
                    spec.addressGroupRef.namespace: "{{ $pathIndexNamespace }}"
                  k8sResourceToFetch: 
                    apiGroup: "netguard.sgroups.io"
                    apiVersion: "v1beta1"
                    plural: "networkbindings"
                    namespace: "{{ $pathIndexNamespace }}"
                  additionalReqsDataToEachItem:
                    - 1
                type: EnrichedTable

          - key: host-binding
            label: Host Binding
            children:
              - data:
                  baseprefix: /openapi-ui # TODO: template baseprefix value
                  cluster: '{{ $pathIndexCluster }}'
                  customizationId: stock-namespace-/netguard.sgroups.io/v1beta1/hostbindings-ag
                  id: conditions-table
                  pathToItems: .items
                  withoutControls: false
                  namespace: "{{ $pathIndexNamespace }}"
                  isNamespaced: true
                  dataForControls:
                    plural: hostbindings
                    apiVersion: v1beta1
                    apiGroup: netguard.sgroups.io
                  fieldSelector:
                    spec.addressGroupRef.name: "{{ $pathIndexResName }}"
                    spec.addressGroupRef.namespace: "{{ $pathIndexNamespace }}"
                  k8sResourceToFetch: 
                    apiGroup: "netguard.sgroups.io"
                    apiVersion: "v1beta1"
                    plural: "hostbindings"
                    namespace: "{{ $pathIndexNamespace }}"
                  additionalReqsDataToEachItem:
                    - 2
                type: EnrichedTable
{{ end }}
