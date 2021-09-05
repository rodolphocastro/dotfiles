FROM mcr.microsoft.com/powershell AS base
SHELL ["pwsh", "-Command"]
RUN Install-Module -Name PSScriptAnalyzer -Scope AllUsers -Force
RUN Import-Module PSScriptAnalyzer

FROM base AS lintPowershell
WORKDIR /src
COPY [".", "."]
RUN Invoke-ScriptAnalyzer .
WORKDIR /src/powershell
RUN Invoke-ScriptAnalyzer .

FROM mcr.microsoft.com/powershell AS basePwsh
WORKDIR /src
COPY [".", "."]
RUN bash -n ./.bashrc
RUN bash -n ./bootstrap.sh
