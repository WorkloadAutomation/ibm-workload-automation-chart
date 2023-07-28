{{/* vim: set filetype=mustache: */}}
{{/*
Create common master service name.
*/}}
{{- define "waMdm.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waserver" -}}
{{- end -}}
{{- define "waDwc.ServiceName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s" $name "waconsole" -}}
{{- end -}}
{{- define "waconsole.ConfigName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "waconsole" "config" -}}
{{- end -}}
{{- define "waconsole.SecretName" -}}
{{- $name := default .Chart.Name .Release.Name -}}
{{- printf "%s-%s-%s" $name "waconsole" "secret" -}}
{{- end -}}
{{- define "waconsole.packagesUrl" -}}
{{- $name := default .Release.Name -}}
{{- printf "%s%s-%s" "http://" $name "nginx-service:8080/" -}}
{{- end -}}
{{/*
Create common master username.
*/}}
{{- define "wa.console.waUser" -}}
{{- $name := default .Release.Name }}
{{- printf "%s-%s-%s" .Release.Namespace $name "console-wauser" -}}
{{- end -}}
