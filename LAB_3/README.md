## MDE_LAB3

| RF  | Description                                                                                | Status |
| --- | ------------------------------------------------------------------------------------------ | ------ |
| 1   | CRUD estufas, incluindo parametrização ambiental                                           | ✅     |
| 2   | CRUD sensores e frutas, incluindo simulação de medições                                    | ✅     |
| 3   | Criar encomendas com diferentes frutas e quantidades, verificando disponibilidade em stock |        |
| 4   | Visualizar encomendas feitas e o seu estado (em preparação / em entrega / entregue)        |        |
| 5   | Configurar e simular os níveis de climatização com base nos valores dos sensores           |        |
| 6   | Configurar lógica adaptativa do sistema de climatização consoante ocupação da estufa       |        |
| 7   | Gerar e visualizar automaticamente mensagens de alarme com base em eventos críticos        |        |
| 8   | Criar Diagrama de Classes representando a estrutura da estufa e entidades relacionadas     |        |
| 9   | Criar Diagrama de Sequência mostrando a interação sensores ↔ demónios ↔ atuadores          |        |

### para abrir todos os ficheiros Prolog, numa linha de comandos `git bash`

```bash
swipl golog2_2025.pl Testes/* Funcional_Requirements/*
```

### DÚVIDAS:

`No RF1: É suposto criar_fruta individual? eu assumi criar um lote, parece-me mais realista.`

**Depois ve-se se é preciso**

`No RF2: Não me faz sentido mudar a estufa de uma fruta, deixei caso seja necessário mais no final.`

**Tudo tem que ser alteravel, nao vale a pena nao implementar por preguica, apenas verifca-se se a estufa dada existe e pronto**
