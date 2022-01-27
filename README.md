#           **_NGC - Framework_**
_______________________________________________

___° Variadades de variáveis de entradas do rótulo principal:___

(As funções abaixo serão somente utilizadas dentro das pontes: Usufruidores & Services) 

 Como montar um "Service" de forma adequada => 

```lua

local NGC = "Coloque o diretório do 'Framework' aqui.";


local Service = NGC.Create{

    -- Dados principais por primeiro:

    Name = "Nome do seu 'Service'";
    StorageData = { };

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


local Usufruidor = NGC.Create{

    -- Dados principais por primeiro:

    Name = "Nome do seu 'Usufruidor'";
    StorageData = { };

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
