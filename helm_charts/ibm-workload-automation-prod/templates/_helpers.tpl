{{/* vim: set filetype=mustache: */}}
{{/*
Create common master service name.
*/}}
{{- define "waMdm.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waserver" -}}
{{- end -}}
{{/*
Create common master username.
*/}}
{{- define "wa.waUser" -}}
{{- $name := default "wauser" }}
{{- printf "%s" $name -}}
{{- end -}}
{{/*
Returns the labels 
*/}}
{{- define "wa.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name | quote}}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
helm.sh/chart: {{ .Chart.Name | quote }}
release: {{ .Release.Name | quote }}
{{- range .Values.global.customLabels }}
{{ .name }}: {{ .value | quote }} 
{{- end}}
{{- end -}}
