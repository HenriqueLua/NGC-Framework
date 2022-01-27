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


```
