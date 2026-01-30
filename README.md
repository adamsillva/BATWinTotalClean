# WinTotalClean (.bat)

[![Download](https://img.shields.io/badge/Download-BATWinTotalClean.bat-blue?style=for-the-badge)](https://github.com/adamsillva/BATWinTotalClean/releases/tag/bat)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-blue?style=for-the-badge)](#requisitos)

Script em batch para limpar pastas temporárias do Windows e do usuário logado, incluindo Prefetch. Ao executar, solicita elevação de privilégios (UAC) e realiza a limpeza de forma silenciosa, ignorando arquivos em uso.

## Recursos
- Limpa temporários do usuário: `%TEMP%`, `%TMP%`, `%LocalAppData%\Temp`
- Limpa temporários do sistema: `%SystemRoot%\Temp`
- Limpa `%SystemRoot%\Prefetch`
- Solicita execução como Administrador (UAC) quando necessário
- Lida com caminhos com espaços e ignora erros de arquivos bloqueados

## Pastas limpas
- Usuário:
  - `%TEMP%`
  - `%TMP%`
  - `%LocalAppData%\Temp`
- Sistema:
  - `%SystemRoot%\Temp`
  - `%SystemRoot%\Prefetch`

## Requisitos
- Windows 10 ou 11
- PowerShell disponível (padrão do Windows moderno)
- Permissão de Administrador para limpar pastas do sistema (Temp e Prefetch)

## Download
- Baixe o arquivo .bat pela página de releases: [Download do BATWinTotalClean.bat](https://github.com/adamsillva/BATWinTotalClean/releases/tag/bat)

## Instalação
1. Copie o arquivo `WinTotalClean.bat` para uma pasta em seu computador.
2. Opcional: fixe um atalho no menu Iniciar ou Barra de Tarefas.

## Uso
1. Dê duplo clique,
2. Confirme o prompt do Controle de Conta de Usuário (UAC) para executar como Administrador.
3. Aguarde alguns segundos; não há mensagens durante a limpeza.

> Dica: Feche programas e navegadores antes de rodar para liberar arquivos em uso e maximizar a limpeza.

## Execução como Administrador
O script verifica privilégios usando `fltmc`. Se não estiver elevado, reexecuta automaticamente via PowerShell com `Start-Process -Verb RunAs` e solicita confirmação do UAC.

## Funcionamento (resumo)
```bat
@echo off
fltmc >nul 2>&1 || (powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
setlocal
set "U_TEMP=%TEMP%"
set "U_TMP=%TMP%"
set "U_LTEMP=%LocalAppData%\Temp"
set "W_TEMP=%SystemRoot%\Temp"
set "W_PREFETCH=%SystemRoot%\Prefetch"
call :clean "%U_TEMP%"
call :clean "%U_TMP%"
call :clean "%U_LTEMP%"
call :clean "%W_TEMP%"
call :clean "%W_PREFETCH%"
endlocal
exit /b
:clean
set "DIR=%~1"
if not exist "%DIR%" exit /b
pushd "%DIR%" 2>nul || exit /b
del /f /q *.* 2>nul
for /d %%D in (*) do rd /s /q "%%D"
popd
exit /b
```

## Compatibilidade e limitações
- Arquivos em uso não são removidos; o sistema os recria quando necessário (como Prefetch).
- A exclusão é permanente (não vai para a Lixeira).
- Em ambientes corporativos, políticas de grupo podem impedir a limpeza de algumas pastas.

## Automação (Agendador de Tarefas)
Você pode agendar rodadas periódicas:
1. Abra o Agendador de Tarefas.
2. Crie uma nova tarefa, marque “Executar com privilégios mais altos”.
3. Em “Ações”, aponte para o caminho completo do `limpar_temp.bat`.
4. Defina gatilhos (ex.: ao fazer logon ou diariamente).

## Perguntas frequentes
- “Preciso sempre executar como Administrador?”  
  Para limpar pastas do sistema (Temp e Prefetch), sim. Para pastas do usuário, não é estritamente necessário.
- “Isso pode afetar a performance?”  
  O Windows recria o conteúdo necessário (especialmente Prefetch). Impacto costuma ser temporário e mínimo.

## Avisos
- Use por conta e risco. Em ambientes de produção, valide previamente com sua equipe de TI.
- Não modifique pastas do sistema fora do escopo acima sem entender consequências.

## Licença
Sugestão: MIT License. Adicione um arquivo `LICENSE` ao repositório conforme sua necessidade.
