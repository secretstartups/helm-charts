{{- define "rbac.tpl" -}}
{{- if .Values.rbac.enabled }}
{{- if .Values.rbac.clusterRole.enabled }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ include "base-service.fullname" . }}
  {{- with .Values.rbac.clusterRole.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.rbac.clusterRole.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
rules:
{{- with .Values.rbac.clusterRole.rules }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- if .Values.rbac.role.enabled }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "base-service.fullname" . }}
  {{- with .Values.rbac.role.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.rbac.role.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
rules:
{{- with .Values.rbac.role.rules }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- if .Values.rbac.clusterRoleBinding.enabled }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ include "base-service.fullname" . }}
  {{- with .Values.rbac.clusterRoleBinding.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.rbac.clusterRoleBinding.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
subjects:
  - kind: ServiceAccount
    name: {{ include "base-service.serviceAccountName" . }}
    namespace: {{ .Release.Namespace }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ .Values.rbac.clusterRoleBinding.roleRef | default (include "base-service.fullname" .) }}
{{- end }}

{{- if .Values.rbac.roleBinding.enabled }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "base-service.fullname" . }}
  {{- with .Values.rbac.roleBinding.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.rbac.roleBinding.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
subjects:
  - kind: ServiceAccount
    name: {{ include "base-service.serviceAccountName" . }}
    namespace: {{ .Release.Namespace }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ .Values.rbac.roleBinding.roleRef | default (include "base-service.fullname" .) }}
{{- end }}
{{- end }}

{{- if .Values.serviceAccount.workspacePerms }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "base-service.fullname" . }}-workspace-perms
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs:
    - create
    - delete
    - list
    - patch
    - update
    - watch
{{- with .Values.serviceAccount.extraRules }}
{{ toYaml . | nindent 2 }}
{{- end }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "base-service.fullname" . }}-workspace-perms
subjects:
  - kind: ServiceAccount
    name: {{ include "base-service.fullname" . }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "base-service.fullname" . }}-workspace-perms
{{- end }}
{{- end -}}
