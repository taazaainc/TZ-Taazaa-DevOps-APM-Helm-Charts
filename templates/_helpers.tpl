{{/*
Expand the name of the chart.
*/}}
{{- define "dev-apm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "dev-apm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label value.
*/}}
{{- define "dev-apm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dev-apm.labels" -}}
helm.sh/chart: {{ include "dev-apm.chart" . }}
{{ include "dev-apm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dev-apm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dev-apm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name
*/}}
{{- define "dev-apm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dev-apm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image helper — prepends global registry if set
*/}}
{{- define "dev-apm.image" -}}
{{- $reg := .global.imageRegistry -}}
{{- $repo := .image.repository -}}
{{- $tag  := .image.tag | default "latest" -}}
{{- if $reg -}}
{{- printf "%s/%s:%s" $reg $repo $tag -}}
{{- else -}}
{{- printf "%s:%s" $repo $tag -}}
{{- end -}}
{{- end }}

{{/*
ClickHouse password — from secret or plain value
*/}}
{{- define "dev-apm.clickhousePassword" -}}
{{- if .Values.clickhouse.auth.existingSecret -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.clickhouse.auth.existingSecret }}
    key: {{ .Values.clickhouse.auth.existingSecretKey }}
{{- else -}}
value: {{ .Values.clickhouse.auth.password | quote }}
{{- end -}}
{{- end }}
