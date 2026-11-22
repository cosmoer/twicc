# Interface translation glossary

This glossary fixes one translation for each recurring TwiCC term. It keeps
the catalogs consistent across translation updates. The catalogs are the
`frontend/src/i18n/locales/*.json` files. The same terms apply to
the translated help and tip Markdown bodies.

## How to use it

- Read this file before you translate or review any interface text.
- Use the listed word every time the English term has the listed meaning.
- The glossary works per concept, not per word. A word that is listed as
  "avoid" for one English term can still be right for another term.
- Add a row when you introduce a recurring domain term. A term is recurring
  when it appears in several messages. Fill the cells for every supported language.
- When you change a row, update the catalogs and the help and tip bodies in
  the same change.
- Do not use this file for generic words (name, title, open, close,
  create, copy, save, send). Translate them in context.
- The English column shows the lowercase source form. Plural forms appear in
  the notes only when they are irregular or when the plural rule matters.
- Register per language: fr uses "vous", es uses "tú", de uses "du", pt-BR uses "você", zh-CN uses "你".
- Keep identifiers, API field names, command names and keyboard chords in
  English. Examples are `provider`, `peer`, `/goal` and `origin.panel`.

See [Internationalization](internationalization.md) for the catalog rules.

## Core objects

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| session | A conversation thread with an agent, tracked by TwiCC | session | sesión | Sitzung | sessão | 会话 | Do not use "conversation" for the object. de: never keep the English word "Session" in prose. |
| ephemeral session | A session that TwiCC and the provider do not save as a local transcript | éphémère | efímera | flüchtig | efêmera | 临时 | Avoid temporaire, temporal, temporär, temporária. |
| draft | A new session or a set of answers that is not sent yet | brouillon | borrador | Entwurf | rascunho | 草稿 | - |
| parent / child (session) | Sessions linked in a session tree (orchestration) | parent / enfant | padre / hijo | übergeordnet / untergeordnet | pai / filho | 父 / 子 | pt-BR: use "pai" for every parent (session, directory, element, project, scope); avoid "superior". "nível superior" (level) is another concept. |
| message | Text that a user, an agent or a peer sends | message | mensaje | Nachricht | mensagem | 消息 | Avoid de "Meldung". Avoid es and pt-BR "aviso" (it names a toast or an alert). |
| conversation | The flow of messages inside a session | conversation | conversación | Unterhaltung | conversa | 对话 | Do not use for the session object. |
| chat | The Chat tab of a session | chat | chat | Chat | chat | 聊天 | - |
| assistant | The agent side of a conversation (assistant message) | assistant | asistente | Assistent | assistente | 助手 | Do not use for "agent". |
| turn | One cycle of agent work after a user message | tour | turno | Durchgang | turno | 回合 | de compound: Nachrichtendurchgang. Avoid de "Runde" and "Turn". fr: zero and one take the singular. |
| project | A registered directory with its own defaults | projet | proyecto | Projekt | projeto | 项目 | - |
| workspace | A named group of projects | espace de travail | espacio de trabajo | Arbeitsbereich | espaço de trabalho | 工作区 | Do not keep "workspace" in prose. Avoid pt-BR "área de trabalho". |
| worktree | A Git worktree that TwiCC creates for a project | worktree | worktree | Worktree | worktree | 工作树 | Keep the English word in all languages. Plural: worktrees. Do not translate. |
| provider | An AI backend that TwiCC drives (Claude Code, Codex) | fournisseur | proveedor | Anbieter | provedor | 提供方 | Keep `provider` only as a literal API field name. Avoid pt-BR "fornecedor". |
| agent | The AI that works in a session | agent | agente | Agent | agente | 智能体 | de plural: Agenten. |
| subagent | An agent that another agent starts | sous-agent | subagente | Subagent | subagente | 子智能体 | de plural: Subagenten. Avoid de "Unteragent". |
| model | The AI model of a session | modèle | modelo | Modell | modelo | 模型 | - |
| effort | The reasoning effort setting of a model | effort | esfuerzo | Aufwand | esforço | 推理强度 | Keep the fr word "effort". |
| thinking | The extended thinking setting and its content block | réflexion | razonamiento | Thinking | raciocínio | 思考 | de: "Thinking" for the setting, the block header and the content; avoid "Denkvorgang" and "Denkinhalt". Progress verb: fr "réfléchit", es "razonando", de "denkt nach", pt-BR "pensando". |
| goal | The objective that an agent works toward (`/goal`) | objectif | objetivo | Ziel | objetivo | 目标 | Keep the command text `goal` in English. Avoid es and pt-BR "meta" (it is also the Meta key) and fr "but". |
| plan | The plan document that an agent proposes | plan | plan | Plan | plano | 计划 | es and pt-BR use the same word as the subscription plan. Context tells them apart. |
| plan mode | The permission mode in which the agent only plans | mode plan | modo plan | Plan-Modus | modo de planejamento | 计划模式 | Use "planejamento" only in the mode name. |
| subscription plan | The paid plan of a provider account | forfait | plan | Tarif | plano | 套餐 | es and pt-BR use the same word as the agent plan (context tells them apart). Avoid de "Plan" for this meaning. |
| hybrid mode | Mode that runs the real Claude CLI in tmux instead of the programmatic API | mode hybride | modo híbrido | Hybrid-Modus | modo híbrido | 混合模式 | - |
| fast mode | Faster generation, billed on extra usage credits | mode rapide | modo rápido | Fast-Modus | modo rápido | 快速模式 | - |
| mode | A named working state (permission, plan, fast, hybrid) | mode | modo | Modus | modo | 模式 | - |

## Agent control and approvals

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| permission | Access that a tool or an agent needs | autorisation | permiso | Berechtigung | permissão | 权限 | - |
| permission mode | The setting that controls tool permissions | mode d'autorisation | modo de permisos | Berechtigungsmodus | modo de permissão | 权限模式 | - |
| allow | Let a tool, host or request through | autoriser | permitir | erlauben | permitir | 允许 | de: "Erlaubnisregel" (allow rule) and "Erlaubnisliste" (allow list) are the allow terms; "Berechtigungsregel" is the generic permission rule. |
| deny | Block a tool, host or request | refuser | denegar | ablehnen | negar | 拒绝 | fr: same word as refuse. de: "ablehnen" is also refuse and reject; the object tells them apart; avoid "verweigern". pt-BR: "negar"; reserve "recusar" for refuse. |
| approval / approve | The user accepts a tool call or a request | approbation / approuver | aprobación / aprobar | Genehmigung / genehmigen | aprovação / aprovar | 批准 | fr: "approuver" also names the trust decision on a project (see trust). The object tells them apart: approve a request or tool call, versus approve (trust) a project. |
| trust | The human decision that a project is safe | confiance (approuver un projet) | confianza (confiar) | Vertrauen (vertrauen) | confiança (confiar) | 信任 | fr: noun "confiance", verb "approuver" (shared with approve; the object tells them apart). |
| trusted | State of a project that the user trusts | approuvé | de confianza | vertrauenswürdig | confiável | 受信任 | fr: "non de confiance" is ungrammatical, so "approuvé" is the target. The collision with approve is accepted; the object tells them apart. |
| untrusted | State of a project that the user has not approved | non approuvé | sin confianza | nicht vertrauenswürdig | não confiável | 不受信任 | fr: "non approuvé"; "non de confiance" is ungrammatical. es: "sin confianza"; avoid "no confiable". |
| question | A question that the agent asks the user | question | pregunta | Frage | pergunta | 问题 | - |
| answer / response | The reply to a question or a prompt | réponse | respuesta | Antwort | resposta | 回答 | - |
| request (human) | An ask to a person: pairing, MCP connection, approval | demande | solicitud | Anfrage | solicitação | 请求 | fr: "demande"; avoid "requête" for peer, MCP and permission requests. pt-BR: avoid "pedido". |
| request (network) | An HTTP or API call | requête | solicitud | Anfrage | solicitação | 请求 | fr: "requête" for HTTP and API calls, including text-to-speech calls; avoid "demande". |
| pending | Waiting for a decision or an answer | en attente | pendiente | ausstehend | pendente | 待处理 | de: "ausstehend"; avoid "offen" for pending requests. |
| refuse | Decline a peer message or a request, or block a request | refuser | rechazar | ablehnen | recusar | 拒绝 | es and de use the same word for refuse and reject. Tell them apart by the object: the user refuses a message or request; a remote instance or the server rejects. pt-BR: reserve "recusar" for refuse. |
| reject | A remote instance or the server turns something down | rejeter | rechazar | ablehnen | rejeitar | 拒绝 | Same word as refuse in es and de. See the refuse row. pt-BR: "rejeitar", not "recusar". |
| steer | Redirect a running agent with a new message | orienter | dirigir | steuern | orientar | 引导 | - |
| interrupt | Stop the current turn but keep the agent | interrompre | interrumpir | unterbrechen | interromper | 中断 | Reserve the verb for interrupt. Do not use it for stop. |
| stop | Stop the agent or the process | arrêter | detener | stoppen | parar | 停止 | pt-BR: reserve "interromper" for interrupt. de: reserve "beenden" for kill and for finishing work; use "stoppen" for every stop, including stopping speech or a selection. |
| kill | Force-stop a process or a background shell | tuer | terminar | beenden | encerrar | 终止 | fr: "tuer"; reserve "interrompre" for interrupt. es "terminar", pt-BR "encerrar" and de "beenden" also mean finish or close; the object tells them apart. Force-kill labels: fr "forcer l'arrêt", es "forzar cierre", de "Beenden erzwingen", pt-BR "forçar encerramento". |

## Peers (cross-instance messaging)

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| peer | Another TwiCC instance that the user has approved | pair | par | Peer | instância parceira | 对等实例 | Plural: pairs / pares / Peers / instâncias parceiras. Keep `peer` only as an API field name. |
| peer messaging | Messages between two TwiCC instances | messagerie entre pairs | mensajería entre pares | Peer-Messaging | mensagens entre instâncias parceiras | 对等消息 | - |
| pairing | The steps that link two instances | appairage (s'appairer) | emparejamiento (emparejarse) | Kopplung (koppeln) | pareamento (parear) | 配对 | pt-BR: "pareamento / parear", so that "conexão" keeps the meaning of connection; avoid "parceria", "conectar". fr: "appairer"; avoid "associer". |
| relationship | The link between two peers | relation | relación | Beziehung | conexão | 关系 | pt-BR: "conexão" is also the word for connection (see connection). |
| connection | A network connection (peer, MCP, server) | connexion | conexión | Verbindung | conexão | 连接 | pt-BR: "conexão" is also the target for relationship (see pairing and relationship). |
| reconnect | Connect again after a loss or a revoke | reconnecter | reconectar | neu verbinden | reconectar | 重新连接 | - |
| revoke | Cancel the access of a peer or an MCP client | révoquer | revocar | widerrufen | revogar | 撤销 | - |
| instance | One running TwiCC installation | instance | instancia | Instanz | instância | 实例 | - |
| remote | On another instance or machine | distant(e) | remoto(a) | Remote | remoto(a) | 远程 | de: compounds such as "Remote-Instanz". |
| inbox | The list of incoming peer messages | boîte de réception | bandeja de entrada | Posteingang | caixa de entrada | 收件箱 | - |
| verification code | The code that confirms a pairing or an MCP connection | code de vérification | código de verificación | Verifizierungscode | código de verificação | 验证码 | - |
| code verification | The check that a verification code matches | vérification du code | verificación del código | Code-Verifizierung | verificação do código | 验证码校验 | Process, not the code itself. |
| credentials | Secrets that a peer exchanges | identifiants | credenciales | Zugangsdaten | credenciais | 凭据 | - |

## Files, content and tools

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| artifact | A viewable file that an agent produces | artefact | artefacto | Artefakt | artefato | 产物 | - |
| bookmark | The saved state of an artifact | favori | favorito | Lesezeichen | favorito | 收藏 | Avoid fr "signet", es and pt-BR "marcador" (es "marcador" is the word for placeholder). |
| attachment | A file that is attached to a message | pièce jointe | adjunto | Anhang | anexo | 附件 | de plural: Anhänge. |
| attach (a file) | Add a file to a message | joindre | adjuntar | anhängen | anexar | 附加 | es, de and pt-BR use the same verb for files and terminals. The object tells them apart. |
| attach (a terminal) | Connect a terminal from another session | attacher | adjuntar | anhängen | anexar | 连接 | fr: use "rattacher" for a project or a session tree. es, de and pt-BR: same verb as for files. |
| directory | A directory on disk (English "directory") | répertoire | directorio | Verzeichnis | diretório | 目录 | Use the folder word only where English says "folder" (see folder). |
| folder | The word "folder" in English text | dossier | carpeta | Ordner | pasta | 文件夹 | Use only where the English says "folder". |
| path | A file or directory path | chemin | ruta | Pfad | caminho | 路径 | - |
| diff | The difference between two file versions | diff | diff | Diff | diff | 差异（diff） | Keep the English word. |
| branch | A Git branch | branche | rama | Branch | branch | 分支 | Keep the English word in de and pt-BR. fr and es use the official Git word ("branche", "rama"). See Technical terms. |
| repository | A Git repository | dépôt | repositorio | Repository | repositório | 仓库 | - |
| snapshot | A frozen copy of an artifact, as opposed to live | instantané | instantánea | Snapshot | snapshot | 快照 | Keep the value `snapshot` in English in API messages. |
| group | A named group of snippets, combos or projects | groupe | grupo | Gruppe | grupo | 分组 | - |
| link | A URL link, such as a share link | lien | enlace | Link | link | 链接 | - |
| upload | Send a file to TwiCC | téléversement (téléverser) | subida (subir) | Upload (hochladen) | upload (enviar) | 上传 | Avoid fr "téléchargement" (it means download). pt-BR: noun "upload", not "envio"; the verb "enviar" is also the generic "send". |
| snippet | A saved text block that the user inserts | snippet | snippet | Snippet | snippet | 片段 | Keep the English word. Avoid "extrait", "fragmento", "Textbaustein", "trecho". |
| combo | A saved key sequence for the terminal | combo | combo | Kombination | combinação | 组合键 | de: "Kombination"; avoid "Combo". |
| insert | Put a snippet or a placeholder into the composer | insérer | insertar | einfügen | inserir | 插入 | - |
| placeholder | A variable that is resolved when a snippet is inserted | variable | marcador | Platzhalter | placeholder | 占位符 | es: "marcador" is the placeholder word; it is not used for bookmark. |
| comment | A comment on a selection or on code | commentaire | comentario | Kommentar | comentário | 评论 | - |
| preview | A rendered view of a file or an artifact | aperçu (prévisualiser) | vista previa | Vorschau | prévia | 预览 | pt-BR: "prévia"; verb "pré-visualizar"; avoid "visualização". |
| view | A view or display mode of a screen | vue | vista | Ansicht | visualização | 视图 | - |
| summary | A short text that summarizes a session | résumé | resumen | Zusammenfassung | resumo | 摘要 | - |
| timeline | The ordered list of events of a session | chronologie | cronología | Zeitachse | linha do tempo | 时间线 | de: "Zeitachse"; avoid "Zeitleiste". es: avoid "línea de tiempo". |
| compact | Compact view; compact a conversation context | compact (compacter) | compacto (compactar) | kompakt (komprimieren) | compacto (compactar) | 紧凑（压缩） | de: "komprimieren" for the context action; avoid "verdichten". |
| companion | The TwiCC companion script on a dev page | compagnon | Companion | Companion | Companion | Companion | fr translates it; es, de and pt-BR keep the English word. |
| telemetry | Anonymous usage telemetry | télémétrie | telemetría | Telemetrie | telemetria | 遥测 | - |
| score | The model score shown beside effort | score | puntuación | Score | pontuação | 分数 | - |
| history | The past messages or usage of a scope | historique | historial | Verlauf | histórico | 历史 | - |
| context | The context window of a model | contexte | contexto | Kontext | contexto | 上下文 | - |
| prompt | The text that the user sends to start work | prompt | prompt | Prompt | prompt | 提示词 | Keep the English word. |
| tool | A tool that an agent calls | outil | herramienta | Tool | ferramenta | 工具 | Avoid de "Werkzeug". |
| command | A slash command or a command-palette entry | commande | comando | Befehl | comando | 命令 | - |
| workflow | A multi-phase automated run | workflow | flujo de trabajo | Workflow | workflow | 工作流 | The English product word stays in fr, de and pt-BR. |
| script | A script run by TwiCC: a text-to-speech script, or the companion script added to a dev page | script | script | Skript | script | 脚本 | de: always "Skript", never "Script". |

## Processes and tools in a session

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| process | The operating-system process of a provider | processus | proceso | Prozess | processo | 进程 | - |
| terminal | A terminal tab in a session | terminal | terminal | Terminal | terminal | 终端 | Avoid "console", "consola", "Konsole". |
| browser | The Browser tab (embedded page) | navigateur | navegador | Browser | navegador | 浏览器 | de keeps "Browser". Keep `browser` only in literal CLI flags. |
| background shell | A shell command that runs in the background | shell en arrière-plan | shell en segundo plano | Shell im Hintergrund | shell em segundo plano | 后台 Shell | fr: avoid "tâche" for a shell. |
| cron job | A scheduled job of a session | cron | cron | Cron-Job | cron job | 定时任务 | Keep the word "cron" in every language. fr and es plural: "crons". Avoid es "tarea programada". |
| task | An item of the agent's task list (Tasks tab) | tâche | tarea | Aufgabe | tarefa | 任务 | - |

## Layout and interface

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| pane | An area of the session layout (the chat or a docked tool panel) | panneau | panel | Bereich | painel | 窗格 | fr: always "panneau", never "volet". de: "Bereich" is also part of "Arbeitsbereich" (workspace) and "Geltungsbereich" (scope); context tells them apart. |
| panel | A tool view (Git, Files, Settings) | panneau | panel | Bereich | painel | 面板 | Same word as pane in every language. de: same word as pane; context tells them apart. |
| dock | Fix a panel into a pane | ancrer (ancré) | acoplar (acoplado) | andocken (angedockt) | encaixar (encaixado) | 停靠 | pt-BR: avoid "organizar" and "fixar" (pin). |
| gutter | The edge strip that holds minimized panels | gouttière | margen | Randleiste | margem | 边栏 | es "margen" and pt-BR "margem" can read as "margin"; no clearly better word exists. fr: "gouttière" is rare in UI French; keep it. de: "Randleiste", not bare "Leiste". es: avoid "borde". |
| layout | A saved arrangement of panes | disposition | layout | Layout | layout | 布局 | Avoid fr "mise en page". es keeps the English word because "diseño" also means design. fr keeps "disposition" (no ambiguity, the VS Code fr word). |
| tab | A tab in a tab bar | onglet | pestaña | Tab | aba | 标签页 | Avoid de "Registerkarte", "Reiter". Avoid pt-BR "guia". |
| sidebar | The session list on the side | barre latérale | barra lateral | Seitenleiste | barra lateral | 侧边栏 | - |
| display (noun, section label) | A settings or command section about how things appear (not the view-mode concept) | affichage | visualización | Anzeige | exibição | 显示 | pt-BR: "Exibição", "Exibição de horário"; keep "visualização" for view. |
| shortcut | A keyboard shortcut | raccourci | atajo | Tastenkürzel | atalho | 快捷键 | - |
| window | A quota window or a context window | fenêtre | ventana | Fenster | janela | 窗口 | pt-BR: "janela" is right here; it is not the word for a dialog. |
| dialog | A modal window | boîte de dialogue | cuadro de diálogo | Dialog | diálogo | 对话框 | pt-BR: avoid "janela" for a dialog. |
| toast | A short in-app message | notification dans l'application | aviso | Hinweis | aviso | 提示 | fr: the toast shares the word "notification". |
| composer | The message input area of a session | zone de saisie | campo de mensaje | Eingabefeld | campo de mensagem | 输入框 | es: "campo de mensaje"; avoid "editor de mensajes" and "cuadro de redacción". |
| notification | An alert outside the page (system, push) | notification | notificación | Benachrichtigung | notificação | 通知 | Avoid de "Mitteilung". |

## Actions

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| archive / unarchive | Move an item out of the active lists | archiver / désarchiver | archivar / desarchivar | archivieren / dearchivieren | arquivar / desarquivar | 归档 / 取消归档 | - |
| pin | Mark a session as pinned | épingler | fijar | anheften | fixar | 固定 | - |
| mute | Silence the notifications of a session | mettre en sourdine | silenciar | stummschalten | silenciar | 静音 | - |
| hide | Remove an item from the lists without deleting it | masquer | ocultar | ausblenden | ocultar | 隐藏 | fr: dot-prefixed files and directories use "cachés". |
| share | Create a public link (verb) | partager | compartir | teilen | compartilhar | 分享 | - |
| sharing / share (noun) | The sharing feature, a share link or a share host | partage | compartir (compartido) | Freigabe | compartilhamento | 分享 | de: "Freigabe" for the noun, "teilen" for the verb. |
| dismiss | Close a hint or alert without acting | ignorer | descartar | schließen | dispensar | 关闭 | de: "schließen"; "verwerfen" is for discard and "ausblenden" for hide. es: same word as discard; context tells them apart. |
| discard | Throw away unsaved work | abandonner | descartar | verwerfen | descartar | 丢弃 | es: same word as dismiss. de: "verwerfen" is for discard; dismiss targets "schließen". |
| delete | Destroy an item permanently | supprimer | eliminar | löschen | excluir | 删除 | fr: "supprimer" is for delete only. Use "retirer" for remove. |
| remove | Take an item out of a list or a group; the item itself survives | retirer | quitar | entfernen | remover | 移除 | Delete vs remove: delete destroys the item, remove only detaches it. fr: avoid "supprimer" for remove. de: avoid "löschen" for remove. |
| restart | Start a process again | redémarrer | reiniciar | neu starten | reiniciar | 重启 | es: do not use "reiniciar" for reset. |
| reset | Return to defaults | réinitialiser | restablecer | zurücksetzen | redefinir | 重置 | pt-BR: avoid "restaurar" (restore). es: avoid "reiniciar" (restart). |
| refresh | Fetch current data again | actualiser | actualizar | aktualisieren | atualizar | 刷新 | de: "aktualisieren"; use "neu laden" for reload only (also for "force refresh" wording that means a reload). |
| reload | Load the page or the data again | recharger | recargar | neu laden | recarregar | 重新加载 | - |
| update | Change to a newer version or newer data | mettre à jour | actualizar | aktualisieren | atualizar | 更新 | es, de and pt-BR use the same verb as for refresh. The object tells them apart. |
| retry | Try an action again | réessayer | reintentar | erneut versuchen | tentar novamente | 重试 | - |
| rename | Change a name | renommer | renombrar | umbenennen | renomear | 重命名 | - |
| switch | Move to another tab, view, mode or provider | basculer | cambiar | wechseln | mudar (para) | 切换 | fr: "basculer"; avoid "passer" and "changer". pt-BR: use "mudar (para)" for every switch; reserve "alternar" for toggle. |
| toggle | Turn something on or off | afficher/masquer, activer/désactiver | alternar | umschalten | alternar | 切换 | fr: avoid "basculer" for toggle. |
| search | Look for text | rechercher | buscar | suchen | pesquisar | 搜索 | pt-BR: avoid "buscar". |
| show | Make an item visible | afficher | mostrar | anzeigen | mostrar | 显示 | pt-BR: avoid "exibir". |

## States

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| enabled / disabled | A feature is on or off | activé / désactivé | activado / desactivado | aktiviert / deaktiviert | ativado / desativado | 已启用 / 已禁用 | es: "activado"; avoid "habilitado", "deshabilitado", "desabilitado". |
| unread | A session with news since the last visit | non lu | no leído | ungelesen | não lida | 未读 | pt-BR: agree with the noun (session is feminine). |
| scope | The level at which a value applies | portée | ámbito | Geltungsbereich | escopo | 范围 | de: "Geltungsbereich" contains "Bereich" (see pane). |

## Settings, usage and network

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| settings | The settings of the app, a provider or an agent | paramètres | configuración | Einstellungen | configurações | 设置 | Avoid fr "réglages" and es "ajustes". Presets keep their own word (see preset). |
| agent settings | The per-session agent options (model, effort, permission) | paramètres de l'agent | configuración del agente | Agent-Einstellungen | configurações do agente | 智能体设置 | - |
| preset | A saved set of agent settings | préréglage | ajuste predefinido | Preset | predefinição | 预设 | es: "ajuste predefinido" for presets, while settings use "configuración". fr: "préréglage". |
| quota | A usage limit of a provider | quota | cuota | Kontingent | cota | 额度 | - |
| usage | How much of a provider is consumed | utilisation | uso | Nutzung | uso | 用量 | de: "Nutzung" for usage. "Verbrauchsrate" is the burn rate and "verbrauchen" is fine for consuming credits; avoid "Verbrauch" as the noun for usage. |
| burn rate | How fast a quota is consumed | rythme de consommation | tasa de consumo | Verbrauchsrate | taxa de consumo | 消耗速率 | es: avoid "ritmo de consumo". |
| quota wake-up | A scheduled start of a quota window | réveil du quota | reactivación | Aufwecken | início antecipado | 额度唤醒 | es: avoid "despertador". pt-BR: avoid "retomada". |
| extra usage | Usage billed beyond the plan quota | utilisation supplémentaire | uso adicional | Zusatznutzung | uso extra | 额外用量 | es: avoid "uso extra". pt-BR keeps "uso extra". |
| cost | The money cost of a session | coût | costo | Kosten | custo | 成本 | - |
| token (auth) | An access token for authentication. Same word as the LLM token | token | token | Token | token | Token | Keep the English word for both senses. Avoid fr "jeton". |
| password | A password | mot de passe | contraseña | Passwort | senha | 密码 | - |
| credits | A balance of provider credits | crédits | créditos | Guthaben | créditos | 积分 | - |
| host | A host that serves shares or artifacts | hôte | host | Host | host | 主机 | fr: "hôte" is the standard French IT word. Use it everywhere, including backend messages. |
| hostname | The name of a host | nom d'hôte | nombre de host | Hostname | hostname | 主机名 | - |
| address | The URL or network address of an instance | adresse | dirección | Adresse | endereço | 地址 | - |
| origin | The scheme, host and port of a URL (HTTP origin); also the source of an upload | origine | origen | Origin | origem | 源 | de: "Origin"; avoid "Ursprung". |
| MCP | The Model Context Protocol and its clients | MCP | MCP | MCP | MCP | MCP | Keep the English abbreviation. |
| commit | A Git commit | commit | commit | Commit | commit | 提交 | Keep the English word. Verb: see Technical terms. Avoid fr "valider" and es and pt-BR "confirmar" (they mean confirm). |
| viewer / visitor | A person who opens a shared link | visiteur | visitante | Betrachter | visitante | 访问者 | - |
| clipboard | The system clipboard | presse-papiers | portapapeles | Zwischenablage | área de transferência | 剪贴板 | - |
| text-to-speech | The speech output feature | synthèse vocale | texto a voz | Sprachausgabe | leitura em voz alta | 文字转语音 | pt-BR: avoid "conversão de texto em fala". |
| read aloud | Speak a message | lire à voix haute | leer en voz alta | vorlesen | ler em voz alta | 朗读 | - |
| orchestration | Sessions that spawn and manage other sessions | orchestration | orquestación | Orchestrierung | orquestração | 编排 | - |


## Technical terms

The users of TwiCC are developers. Developers say many technical words in
English, whatever their language. The interface must not rename the words
that they use every day. It must still be clear for a reader who does not
know the term.

### Rules

- **Default:** keep an English technical term when developers say it in English
  (commit, diff, prompt, token, shell). Keep it in the interface, the help and
  the tips.
- **Translate** a term when it is an interface concept or a common word with a
  natural, unambiguous word in the language (file, path, tab, clipboard, query).
- **Translate** a term when the kept word would clash with another word of the
  language. Example: fr "stage" means internship, so fr uses "indexer".
- **Official convention:** when a language has a strong official convention (Git
  localization, the VS Code language pack), a row can differ between languages.
  The notes column gives the reason. These differences are intentional.
- **Marker:** `(kept)` in a language cell means the English word stays verbatim
  in that language. A cell without the marker holds a translation, or a word
  that is spelled the same way in the language. Rows in the other sections do
  not use the marker. Their notes say "Keep the English word".
- **Kept terms stay verbatim.** Do not put them in quotes or italics. Do not
  respell them. Do not add a gloss in brackets.
- **Case:** a kept term is lowercase in running text and capitalized at the
  start of a label. de capitalizes every noun, so "Commit", "Branch", "Diff".
  Acronyms and product names keep their form: CLI, MCP, API, OAuth, HEAD, JSON,
  WebSocket, tmux (lowercase).
- **Code spans** stay verbatim: `git log`, `git restore --staged`, `/goal`,
  `bypassPermissions`. Keep key chords in English: `Alt+Shift+B`, never fr
  "Alt+Maj+B".
- **Example paths** stay verbatim in every language: `/path/to/tmux.conf`.
- **Plural:**
  - fr: add "s" (commits, diffs, worktrees). No English irregular plural.
  - es: "s" after a vowel, "es" after a consonant (commits, tags, hashes, regexes, stashes).
  - de: use the forms in the notes (Commits, Branches, Tags, Diffs, Hashes,
    Prompts, Tokens, Proxys, Agenten). Do not invent others.
  - pt-BR: add "s" after the article (os commits, os branches, as tags).
- **Gender of kept terms:**
  - fr: masculine, except "une skill", "une regex", "une sandbox", "la CLI".
  - es: masculine ("el commit", "el tag", "el diff", "el hash", "el prompt",
    "el token", "el shell", "el log", "el cron", "el stage", "el push"), except
    "la skill", "la regex", "la CLI", "la API".
  - de: "der Commit, Branch, Tag, Diff, Hash, Prompt, Cache, Proxy, Stream, Host,
    Port, Tab, Skill, Worktree", "die Shell, CLI", "das Snippet, Token".
  - pt-BR: masculine ("o commit", "o branch", "o diff", "o stash", "o token",
    "o log"), except "a tag", "a skill", "a CLI", "a API".
- **Verbs from kept nouns:**
  - fr: prefer a French verb plus the noun: "créer un commit", "faire un push".
    Avoid "commiter", "pusher", "stasher".
  - es and pt-BR: "hacer" or "fazer" plus the noun: "hacer commit", "fazer push".
    Avoid "commitar", "pushar", "stagear".
  - de: the verbs listed in the notes (committen, stagen, auschecken, pushen).
- **Imperative labels** use the infinitive in fr, es, de and pt-BR.
- **Stay consistent in a pair:** when a row says to translate, never write the
  English word in prose (es "rama", never "branch"). When a row says to keep,
  never translate it in some places.

### Git

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| committer | The person who applied a commit | committer (kept) | committer (kept) | Committer (kept) | committer (kept) | 提交者 | No standard translation exists. |
| author | The person who wrote a commit | auteur | autor | Autor | autor | 作者 | - |
| branch tip | The newest commit of a branch | pointe de la branche | punta de la rama | Branch-Spitze | ponta do branch | 分支末端 | - |
| tag (Git) | A Git tag | tag (kept) | tag (kept) | Tag (kept) | tag (kept) | 标签（tag） | Avoid "étiquette", "etiqueta", "Etikett" and pt-BR "marca": they clash with the generic label. pt-BR gender: "a tag". |
| stage (verb) | Add changes to the Git staging area | indexer | hacer stage | stagen | adicionar ao stage | 暂存 | fr: "indexer" is the official Git fr and VS Code fr word; "stage" means internship in French, so it is not kept. Labels: "Tout indexer", "Hacer stage de todo", "Alle stagen", "Adicionar tudo ao stage". Avoid es and pt-BR "preparar" and de "bereitstellen". |
| unstage (verb) | Remove changes from the staging area | désindexer | sacar del stage | unstagen | remover do stage | 取消暂存 | Labels: "Désindexer", "Sacar todo del stage", "Alle unstagen", "Remover tudo do stage". |
| staged / unstaged | The state badge of a file | indexé / non indexé | en stage / sin stage | Staged / Unstaged | no stage / fora do stage | 已暂存 / 未暂存 | de: capitalized only on a badge; in prose "gestagte Datei", "ungestagt". Backend messages use the same words: "fichier indexé", "gestagte Datei", "no stage". |
| staged (pending apply) | Not Git: a setting that waits to be applied (hybrid switch) | programmée | pendiente | vorgemerkt | pendente | 待应用 | Never reuse the Git stage word for this meaning. |
| untracked | A file that Git does not track | non suivi | sin seguimiento | nicht verfolgt | não rastreado | 未跟踪 | - |
| ignored (by Git) | A file that Git ignores | ignoré par Git | ignorado por Git | von Git ignoriert | ignorado pelo Git | 已被 Git 忽略 | - |
| conflict | A merge conflict | conflit | conflicto | Konflikt | conflito | 冲突 | - |
| merge | Combine two branches; unmerged state | fusionner / non fusionné | fusionar / sin fusionar | zusammenführen / nicht zusammengeführt | merge (kept): fazer merge / sem merge | 合并 | Intentional difference: official Git and GitHub in fr, es and de translate; Git pt-BR keeps "merge" and Brazilian developers say it. Avoid pt-BR "mesclar", "mesclagem". |
| revert | Drop the unsaved edits of an open file and reload the saved version (also the Git revert of a commit) | rétablir | revertir | revertieren | reverter | 还原 | fr has no cognate verb: "rétablir" is the VS Code fr word for "Revert File"; avoid "restaurer" (it names restore) and "annuler" (undo). de: avoid "Zurücksetzen" (reset) and "Rückgängig machen" (undo). |
| checkout | Switch the working copy to a branch or a commit; the working copy itself | checkout (kept) | checkout (kept) | Checkout (kept) | checkout (kept) | 检出 | Verb: fr "faire un checkout", es "hacer checkout", de "auschecken" ("ausgecheckt"), pt-BR "fazer checkout". State "checked out": fr "en checkout", es "en checkout", de "ausgecheckt", pt-BR "em checkout". Source checkout: fr "checkout des sources", es "checkout del código fuente", de "Quell-Checkout", pt-BR "checkout do código-fonte". Avoid fr "extraire". |
| git log | The Git command, quoted in a backend error | `git log` (kept) | `git log` (kept) | `git log` (kept) | `git log` (kept) | `git log`（保留） | Always a code span. A UI label that means the commit history uses the history word: "historique Git", "historial de Git", "Git-Verlauf", "histórico do Git". |
| commit graph | The drawn graph of commits | graphe | gráfico | Graph (kept) | grafo | 提交图 | de keeps the cognate "Graph". |
| Git root | The root directory of a repository | racine Git | raíz de Git | Git-Stammverzeichnis | raiz do Git | Git 根目录 | - |
| clone | Copy a repository | cloner | clonar | klonen | clonar | 克隆 | - |
| upstream | The remote branch that a branch follows | upstream (kept) | upstream (kept) | Upstream (kept) | upstream (kept) | 上游 | - |
| pull / push / fetch (Git) | Git network operations | pull / push / fetch (kept) | pull / push / fetch (kept) | Pull / Push / Fetch (kept) | pull / push / fetch (kept) | 拉取 / 推送 / 获取 | Verbs: fr "faire un push", es "hacer push", de "pushen", "pullen", "fetchen", pt-BR "fazer push". |
| rebase | Replay commits on another base | rebase (kept) | rebase (kept) | Rebase (kept) | rebase (kept) | 变基（rebase） | Verb: fr "faire un rebase", es "hacer rebase", de "rebasen", pt-BR "fazer rebase". |
| stash | Save changes aside | stash (kept) | stash (kept) | Stash (kept) | stash (kept) | 贮藏（stash） | Verb: es "hacer stash", de "stashen", pt-BR "fazer stash". Avoid fr "remisage". |
| cherry-pick | Apply one commit to another branch | cherry-pick (kept) | cherry-pick (kept) | Cherry-Pick (kept) | cherry-pick (kept) | 拣选（cherry-pick） | Keep the hyphen. de verb: "cherry-picken". |
| blame | Per-line authorship view | blame (kept) | blame (kept) | Blame (kept) | blame (kept) | blame（保留） | - |
| hunk | One block of changes in a diff | hunk (kept) | hunk (kept) | Hunk (kept) | hunk (kept) | 代码块（hunk） | Avoid es "fragmento", pt-BR "trecho" and "pedaço". |
| hash | A commit hash | hash (kept) | hash (kept) | Hash (kept) | hash (kept) | 哈希 | es plural "hashes", de plural "Hashes". |
| HEAD | The Git reference to the current commit | HEAD (kept) | HEAD (kept) | HEAD (kept) | HEAD (kept) | HEAD（保留） | Never translate. fr: masculine, "le HEAD actuel". |
| parent / child (commit) | Commits linked by ancestry | parents / enfants | padres / hijos | Eltern-Commit / Kind-Commit | commits pais / filhos | 父 / 子提交 | - |
| push (share update) | Not Git: send an update to a share link | publier | enviar actualización | senden | enviar atualização | 推送更新 | Never use the Git word "push" for this meaning. |
| push (notification) | A push notification to a device | notification push | notificación push | Push-Benachrichtigung | notificação push | 推送通知 | Keep "push" in every language. |

### Development and operations

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| shell | A command shell | shell (kept) | shell (kept) | Shell (kept) | shell (kept) | Shell（保留） | See also background shell. |
| CLI | The command-line interface | CLI (kept) | CLI (kept) | CLI (kept) | CLI (kept) | CLI（保留） | Feminine everywhere: fr "la CLI", es "la CLI", de "die CLI", pt-BR "a CLI". Avoid fr "le CLI" and es "el CLI". Hybrid: "la CLI hybride", "la CLI híbrida", "Hybrid-CLI", "a CLI híbrida". |
| permission prompt | The dialog that asks to approve a tool call | demande d'autorisation | solicitud de permiso | Berechtigungsabfrage | solicitação de permissão | 权限请求 | The word "prompt" alone means the user text (see prompt). |
| system prompt | The system instructions of a session | prompt système | prompt de sistema | System-Prompt | prompt de sistema | 系统提示词 | - |
| token (LLM) | A unit of model text | token (kept) | token (kept) | Token (kept) | token (kept) | Token（保留） | Same word as token (auth). de plural: "Tokens"; neuter "das Token". |
| API key | A secret key for an API | clé d'API | clave de API | API-Schlüssel | chave de API | API 密钥 | - |
| API, SDK, OAuth, MCP, URL, UUID, HTTP, HTTPS, WebSocket, localhost | Acronyms and protocol names | API, SDK, OAuth, MCP, URL, UUID, HTTP, HTTPS, WebSocket, localhost (kept) | same (kept) | same (kept) | same (kept) | 相同（保留） | Verbatim. Gender: fr "l'API", es "la API", pt-BR "a API". |
| MCP client | A client of the TwiCC MCP server | client MCP | cliente MCP | MCP-Client | cliente MCP | MCP 客户端 | - |
| endpoint | A URL that serves an API | endpoint (kept) | endpoint (kept) | Endpoint (kept) | endpoint (kept) | 端点 | Avoid fr "point de terminaison", es "punto de conexión", de "Endpunkt". |
| tunnel | A network tunnel to reach TwiCC | tunnel | túnel | Tunnel | túnel | 隧道 | Same word as English in fr and de. |
| remote access | Reach TwiCC from another machine | accès à distance | acceso remoto | Fernzugriff | acesso remoto | 远程访问 | - |
| proxy | A proxy server | proxy (kept) | proxy (kept) | Proxy (kept) | proxy (kept) | 代理 | de plural: "Proxys". |
| cache | A cache | cache (kept) | caché | Cache (kept) | cache (kept) | 缓存 | es: "caché" is the standard Spanish spelling of the same word. |
| daemon | A background service process | daemon (kept) | daemon (kept) | Daemon (kept) | daemon (kept) | 守护进程 | - |
| PID | The operating-system process number | PID (kept) | PID (kept) | PID (kept) | PID (kept) | PID（保留） | Avoid fr "ID du processus", de "Prozess-ID" and pt-BR "ID do processo" when the label means the PID. |
| ID | An identifier | ID | ID | ID | ID | ID | One word everywhere, also in backend errors. Avoid fr "identifiant". es: "el ID". |
| LAN / loopback | Network kinds of an address | réseau local / loopback (kept) | red local / loopback (kept) | lokales Netzwerk / Loopback (kept) | rede local / loopback (kept) | 局域网 / 回环 | - |
| socket | A network or tmux socket | socket (kept) | socket (kept) | Socket (kept) | socket (kept) | 套接字（socket） | fr: "le socket". |
| example path | A placeholder path in an input hint | `/path/to/...` (kept) | `/path/to/...` (kept) | `/path/to/...` (kept) | `/path/to/...` (kept) | `/path/to/...`（保留） | Do not translate the segments (fr "/chemin/vers/", es "/ruta/a/"). |
| payload | The data of a request or a message | payload (kept) | payload (kept) | Payload (kept) | payload (kept) | 负载（payload） | Use the plain word "données" / "datos" / "Daten" / "dados" in prose where no technical term is needed. Do not mix renderings for the same label. |
| stream / streaming | Live output of a response; the streaming feature | stream / streaming (kept) | stream / streaming (kept) | Stream / Streaming (kept) | stream / streaming (kept) | 流 / 流式 | Avoid fr "flux", es "flujo", pt-BR "fluxo" (es "flujo" clashes with "flujo de trabajo"). de verb: "streamen". |
| log (noun) | A log of events or output | log (kept) | log (kept) | Log (kept) | log (kept) | 日志 | Plural "logs" / "Logs". Avoid fr "journal", es "registro", de "Protokoll". pt-BR: "histórico" is only for history. |
| debug | Debug mode or view | débogage | depuración | Debug (kept) | depuração | 调试 | Intentional difference: "Debuggen" is the German IT standard; fr, es and pt-BR use the official IDE word. |
| dump | A raw dump of data to a file | dump (kept) | dump (kept) | Dump (kept) | dump (kept) | 转储 | Verb: fr "écrire un dump", es "generar un dump", de "Dump erstellen", pt-BR "gerar um dump". Avoid "export" (a different feature), es "volcado", pt-BR "gravação". |
| lint | Static code check | lint (kept) | lint (kept) | Lint (kept) | lint (kept) | lint（保留） | de verb: "linten". |
| plugin | A TwiCC or provider plugin | plugin (kept) | plugin (kept) | Plugin (kept) | plugin (kept) | 插件 | - |
| skill | An agent skill | skill (kept) | skill (kept) | Skill (kept) | skill (kept) | 技能（skill） | Feminine in fr, es, pt-BR ("une skill", "la skill", "uma skill"); de "der Skill". Avoid "compétence", "habilidad", "Fähigkeit", "habilidade". |
| sandbox | The Codex execution sandbox | sandbox (kept) | sandbox (kept) | Sandbox (kept) | sandbox (kept) | 沙箱 | fr: "une sandbox". Avoid "bac à sable", "caja de arena", "caixa de areia". |
| regex | A regular expression | regex (kept) | regex (kept) | Regex (kept) | regex (kept) | 正则表达式 | fr: "une regex". es plural "regexes", de plural "Regexes". Avoid fr "regexp", pt-BR "expressão regular". |
| glob | A file pattern with wildcards | glob (kept) | glob (kept) | Glob (kept) | glob (kept) | glob（保留） | - |
| wildcard | The `*` character of a pattern | caractère générique | comodín | Platzhalter | curinga | 通配符 | - |
| changelog | The list of release changes | changelog (kept) | changelog (kept) | Changelog (kept) | changelog (kept) | 更新日志 | Avoid fr "journal des modifications", es "registro de cambios", de "Änderungsprotokoll". |
| fallback | A model that is used when the first one fails | de secours | alternativo | Ersatz- | alternativo | 后备 | Translate in sentences: fr "modèle de secours", es "modelo alternativo", de "Ersatzmodell", pt-BR "modelo alternativo". Avoid de "Fallback". |
| spawn | An agent starts another session | lancer ("lancée par") | generar ("generada por") | starten ("gestartet von") | criar ("criada por") | 派生 | Do not use "spawn" or "spawnen" in prose. |
| frame / iframe | An embedded page frame | frame / iframe (kept) | frame / iframe (kept) | Frame / iframe (kept) | frame / iframe (kept) | frame / iframe（保留） | Avoid es "marco". |
| header (HTTP) | An HTTP header | en-tête | encabezado | Header (kept) | cabeçalho | 标头 | de: avoid "Kopfzeile". |
| screenshot | An image of the screen | capture d'écran | captura de pantalla | Screenshot (kept) | captura de tela | 截图 | Intentional difference: fr, es and pt-BR use the term of their operating systems; de uses the German IT standard. |
| app | The Android application | application | aplicación | App (kept) | aplicativo | 应用 | One word per language. Avoid es "app" and pt-BR "app". |
| Chrome MCP | The Chrome MCP server | Chrome MCP | Chrome MCP | Chrome-MCP | Chrome MCP | Chrome MCP | Product name: fr and es keep the English order. Avoid fr "MCP Chrome" and es "MCP de Chrome". |
| Markdown, JSON, HTML, SVG, PDF, Mermaid, Android, Chrome | Format and product names | verbatim | verbatim | verbatim | verbatim | 原样保留 | Capitalize "Markdown". |

### Interface words

| English | Meaning in TwiCC | fr | es | de | pt-BR | zh-CN | Avoid / notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| popover | A small floating panel | popover (kept) | popover (kept) | Popover (kept) | popover (kept) | 弹出框 | Avoid fr "fenêtre" and es "menú" for a popover. |
| overlay | A layer that covers part of the screen | superposition | superposición | Overlay (kept) | sobreposição | 遮罩层 | Intentional difference: "Overlay" is the German UI standard. |
| inline | Shown inside the chat, not in a separate view | inline (kept) | inline (kept) | Inline (kept) | inline (kept) | 内联 | Avoid fr "en ligne" and es "en línea": they read as "online". Avoid fr "incorporé". |
| template | A text pattern with variables (worktree directory template) | template (kept) | plantilla | Vorlage | template (kept) | 模板 | fr and pt-BR keep the English word because "modèle" and "modelo" name the AI model. |
| slash command | A `/command` typed in the composer | commande slash | comando slash | Slash-Befehl | comando slash | 斜杠命令 | The `/word` stays verbatim. |
| viewport | The visible area of a page | viewport (kept) | viewport (kept) | Viewport (kept) | viewport (kept) | 视口 | Avoid fr "fenêtre d'affichage". |
| scroll | Move the visible part of a list | défiler | desplazar | scrollen (kept) | rolar | 滚动 | Prefer a label such as "go to top" / "go to bottom". Intentional difference: no natural German verb exists. |
| hover | Pointer over an element | survol | al pasar el cursor | Hover (kept) in compounds; "darüberfahren" as verb | passar o mouse | 悬停 | Do not leave the English word in fr, es and pt-BR. |
| icon | A small picture that stands for an item | icône | icono | Icon | ícone | 图标 | de: "Icon", never "Symbol". |
| badge | A small status label | badge (kept) | badge (kept) | Badge (kept) | badge (kept) | 徽标 | - |
| chip | A small pill-shaped control | chip (kept) | chip (kept) | Chip (kept) | chip (kept) | 标签（chip） | - |
| tooltip | A small hint on hover | infobulle | información sobre herramientas | Tooltip (kept) | dica de ferramenta | 工具提示 | Intentional difference: "Tooltip" is the German UI standard. |
| key names | Names of keyboard keys | touche Meta | tecla Meta | Meta-Taste | tecla Meta | Meta 键 | Chords stay English: `Alt+Shift+B`, `Ctrl+K`. |
