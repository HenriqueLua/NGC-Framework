#                             **_NGC - Framework_**
_______________________________________________________________________________________

# ___° Variadades de variáveis de entradas do rótulo principal:___

(As funções abaixo serão somente utilizadas dentro das pontes: Usufruidores & Services) 

 Como montar um "Service" de forma adequada => 

```lua

local NGC = "Coloque o diretório do 'Framework' aqui.";


local Service = NGC.CreateService{

    -- Dados principais por primeiro:

    Name = "Nome do seu 'Service'";
    StorageData = { };
    Events = {
        -- [Crie seus próprios eventos]
        EventsDeep = {}; -- [Armazenamento profundo. Aqui ficará seus eventos para que você possa utiliza-los novamente!]
    };

    -- > ["BETA VARIABLES!"] < -- 

    -- Dados de modo de controle de entradas ao seu serviço:

    entryBlocking = false | true -- [Defina se você quer que os clientes possam acessar seu serviço ou não]

}

function Service:Running()
    -- #Correrá antes do jogo (Pré-processamento).
end

function Service:AfterRunning()
    -- #Correrá quando o jogo começar (Pós-processamento).
end

--[[ Pré-lançamento

   Abaixo temos uma função que irá ser acionada de formato tabela.

    Praticamente você dará uma função que você quer que aconteça, e em tal data
    a sua função será acionada, de forma que todos os servidores vejam um "Evento ao vivo" por assim dizer.


--]]

Service:DeferLive{Date = {Second, Minute, Hour, Day, ...}}

```

 Como montar um "Usufruidor" de forma adequada => 

```lua

local NGC = "Coloque o diretório do 'Framework' aqui.";


local Usufruidor = NGC.CreateUsufruidor{

    -- Dados principais por primeiro:

    Name = "Nome do seu 'Usufruidor'";
    StorageData = { };
    Events = {
        -- [Crie seus próprios eventos]
        EventsDeep = {}; -- [Armazenamento profundo. Aqui ficará seus eventos para que você possa utiliza-los novamente!]
    };

    -- > ["BETA VARIABLES!"] < -- 

    -- None variables...

}

function Usufruidor:Running()
    -- #Correrá antes do jogo (Pré-processamento).
end

function Usufruidor:AfterRunning()
    -- #Correrá quando o jogo começar (Pós-processamento).
end

--[[ Pré-lançamento

   Abaixo temos uma função que irá ser acionada de formato tabela.

    Praticamente você dará uma função que você quer que aconteça, e em tal data
    a sua função será acionada, de forma que todos os servidores vejam um "Evento ao vivo" por assim dizer.


--]]

Service:DeferLive{Date = {Second, Minute, Hour, Day, ...}}


```

##         **_Criação de eventos e armazenamentos de eventos profundos:_**
_______________________________________________________________________________________


# _Como funciona a criação de um evento?_
  
  Um evento é criado assim que adicionado uma tabela de eventos, que quando ela é adicionada e contém pelo menos um evento então automaticamente uma pasta de armazenamentos externo e interno são criados. Para facilitar a criação de um evento para quaisquer tipo de programador "Lua" eu irei vindo atulizando o sistema sempre e, adicionando novas ferramentas para possibilitar ao programador uma extensão exclusiva e potente!

# _Por que devo utilizar esse sistema para a criação de eventos?_

 Normalmente essa ferramenta contém algumas opções extras no desenvolvimento de funções do seu jogo. 
  Teremos opções para lacrar/trancar a possibilidade de entrada do cliente ao servidor e vire versa. Além disso teremos opções como exemplo: aprimoração de desempenho (Que irá ajudar no código como exemplo: avisar dicas do que você poderia usar para manter o código limpo, adicionar funções automáticas para melhorá o desempenho e até irá lhe informar caso o Roblox adicione alguma função extra no futuro).

# _Como você deve usá-lo de forma adequada:_

```lua

-- [Preocupe-se de fazer isso dentro de uma criação de um usufruidor/service]

Events = {

    -- [Nunca se esqueça de fazer uma enumeração de seus eventos/sinais]

    [1] = {"Nome do evento", "Tipo do evento como exemplo: BindableEvent", "Nome do usufruidor/service", script --[[(Certifique-se de colocar o script que está criando isso)]]}

    --[Em desenvolvimento/explicado em breve].

    EventsDeep = {}

};

```

##  **Acessando a parti do Singleton:**
_______________________________________________________________________________________

# _Como funciona a função Singleton?_
  
  A função "GetSingleton" é utilizada para acessar diferentes usufruidores/serviços dentre um deles. Tanto o _Serviço_ pode acessar os _Usufruidores_ quanto o _Usufruidor_ no _Serviço_.
  De forma lógica acessar um "Serviço" através de um Usufruidor pode expor os dados do servidor, então é por isso que existe uma função chamada "entryBlocking" (Veja mais em: `# ___° Variadades de variáveis de entradas do rótulo principal:___`)