{{/* vim: set filetype=mustache: */}}
{{/*
Create common master service name.
*/}}
{{- define "waMdm.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waserver" -}}
{{- end -}}
{{- define "waserver.SecretName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "waserver" "secret" -}}
{{- end -}}
{{/*
Create common master username.
*/}}
{{- define "wa.agent.waUser" -}}
{{- $name := default .Release.Name }}
{{- printf "%s-%s" $name "agent" -}}
{{- end -}}
{{- define "waAgt.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waagent" -}}
{{- end -}}
