{{/* vim: set filetype=mustache: */}}

{{/*
Create common DDM service name.
*/}}
{{- define "waDdm.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waddm" -}}
{{- end -}}

{{- define "waddm.ConfigName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "waddm" "config" -}}
{{- end -}}

{{- define "waddm.SecretName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "waddm" "secret" -}}
{{- end -}}

{{/*
Create common DDM username.
*/}}
{{- define "wa.ddm.waUser" -}}
{{- $name := default .Release.Name -}}
{{- printf "%s-%s" $name "waddm" -}}
{{- end -}}