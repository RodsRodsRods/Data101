@echo off

for /f "tokens=1-3 delims=/. " %%a in ('date /t') do (
    set "dia=%%a"
    set "mes=%%b"
    set "ano=%%c"
)

rem Defina as variáveis
rem Defina as variáveis
set DB_USER=rodolpho.franzao
set DB_PASSWORD=m7KaLZGaX3k7aER
set DB_HOST=sql-crefaz-bi.database.windows.net
set DB_NAME=db-crefaz-bi
set TABLE_NAME=report.AcompanhamentoDeStatus2
set OUTPUT_FOLDER="\\192.168.0.4\Gestao_Dados\1. Relatorios\ArquivosCrefazOn\acompStatus"
REM Obter a data atual
set OUTPUT_FILE=%OUTPUT_FOLDER%\acompanhamento-de-status2_%ano%%mes%.csv
rem set OUTPUT_XLSX_FILE=%OUTPUT_FOLDER%\acompanhamento-de-status2_202404_2.xlsx
set TEMP_FILE=%OUTPUT_FOLDER%\temp.csv
set COLUMN_HEADER=COD_PROPOSTA;TIPO_PROPOSTA;CPFCNPJ;TIPO_CLIENTE;USUARIO;DEPARTAMENTO;CPFCNPJ_AGENTE;AGENTE;DATA;HORA;STATUS;DECISAO;PRODUTO;DT_AG_ANALISE

rem Exporta os dados para um arquivo temporário
bcp "SELECT * FROM %TABLE_NAME% WITH(NOLOCK)" queryout %TEMP_FILE% -S %DB_HOST% -d %DB_NAME% -U %DB_USER% -P %DB_PASSWORD% -c -t; -C 65001

rem Adiciona manualmente os nomes das colunas no início do arquivo CSV
echo %COLUMN_HEADER% > %OUTPUT_FILE%

rem Concatena o arquivo temporário ao arquivo final
type %TEMP_FILE% >> %OUTPUT_FILE%

rem Remove o arquivo temporário
del %TEMP_FILE%

rem Converte o arquivo CSV para XLSX usando powershell
rem powershell -Command "& {Import-Csv \"%OUTPUT_FILE%\" -Delimiter ';' | Export-Excel -Path \"%OUTPUT_XLSX_FILE%\" -Show}"

rem Exibe uma mensagem informando que a exportação foi concluída
rem echo Exportação para Excel concluída com sucesso!

rem Aguarda uma entrada antes de fechar a janela
pause
