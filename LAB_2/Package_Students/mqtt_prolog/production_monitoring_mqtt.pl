:- use_module(library(shlib)).

%Defining the MQTT broker details
%mqtt_broker('tcp://localhost:1883').     % case working locally
mqtt_broker('tcp://192.168.250.201:1883'). % case working with lab1.3
                                             % MQTT Broker

:-dynamic mqtt_library_loaded/0.
:-dynamic mqtt_monitoring_handler/1.


load_mqtt_library:-
   not(mqtt_library_loaded),
   % loads the library mqtt_prolog.dll
   use_foreign_library(foreign('mqtt_prolog.dll')),
   assert(mqtt_library_loaded),
   !;
   true.

create_monitoring_client:-
    load_mqtt_library,
    not(mqtt_monitoring_handler(_)),
    mqtt_broker(Broker_URL),
    mqtt_create_client(production_monitoring, Broker_URL, Handler),
    % the Handler is the C/C++ void *pointer inside the DLL.
    assert(mqtt_monitoring_handler(Handler)),
    mqtt_connect(Handler, _Result),
    !;
    true.

production_monitoring_on_connect_failure(_Handler):-
   format('failure connection of ~w~n', [production_monitoring]).

production_monitoring_on_connect_success(Handler):-
   format('success connection of ~w~n', [production_monitoring]),
   mqtt_subscribe(Handler, 'production1/temperature', 1, _Result1).

   %subscribe the other related topics

production_monitoring_on_message_arrived('production1/temperature', Message,_Handler):-
   format('mqtt topic: ~w~n',['production1/temperature']),
   format('mqtt message: ~w~n~n',[Message]).


% create the other topics on_message_arrived



