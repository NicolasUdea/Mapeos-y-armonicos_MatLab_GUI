function Practica1(atr, ~)
% Práctica 1
% Objetivo: Crear interfaces gráficas para la simulación de mapeos, en donde se pueda introducir un dominio a través de una ventana de ingreso de dominio y de mapeo y que se muestre en que es mapeado dicho dominio

% Crear una interfaz gráfica que solicite, el dominio, y la función que mapea el dominio
% Que solicite el intervalo donde se desea ver el dominio mapeado 
% Que el gráfico de la función dominio se vea de forma paralela al mapeo en que es mapeado ese dominio

% 1. Crear una interfaz gráfica que solicite, una función componente de una función f(z), es decir U ó V
% 2. Identificar si dicha función es armónica
% 3. En caso afirmativo, el sistema debe hallar el armónico conjugado y mostrar la función f(z)
    clf;
    map_button=uicontrol('Style','pushbutton','Position',[240,210,120,20],...
        'String','Mapeo de funciones','Callback',@Map_submenu);
    arm_button=uicontrol('Style','pushbutton','Position',[240,180,120,20], ...
        'String', 'Funciones armónicas', 'Callback', @Arm_submenu);

    function Map_submenu(atr, ~)
        clf;
        dom_title = uicontrol("Style",'text','String', 'Ingrese Dominio: ', ...
            'Position', [240,300,120,20])
        dom_box=uicontrol('Style','edit','Position',[240,285,120,20]);
        map_title = uicontrol("Style",'text','String', 'Ingrese Mapeo: ', ...
            'Position', [240,260,120,20])
        map_box=uicontrol('Style','edit','Position',[240,245,120,20]);
        interval_title = uicontrol("Style",'text','String', 'Ingrese Intervalo: ', ...
            'Position', [240,220,120,20])
        interval_box=uicontrol('Style','edit','Position',[240,205,120,20]);
        exe_button=uicontrol('Style','pushbutton','Position',[240,175,120,20],...
        'String','Ejecutar','Callback',@Mapeo);
        ret_button=uicontrol('Style','pushbutton','Position',[240,60,120,20], ...
                'String', 'Regresar', 'Callback', @Practica1)
        

        function Mapeo(atr,~)
            x=sym('x');
            y=sym('y');
            z=sym('z');
            dom_funct=str2sym(get(dom_box,'string'))
            map_funct=str2sym(get(map_box,'string'))    
            f1=subs(map_funct,z,x+1i*y)
            f2=subs(f1,y,dom_funct);
            u=real(f2);
            v=imag(f2);
            limit = split(get(interval_box, 'string'), ',');
            l_limit = str2double(limit(1));
            r_limit = str2double(limit(2));
            interval=linspace(l_limit,r_limit, (r_limit-l_limit)*10)
            u1=eval(subs(u,x,interval));
            v1=eval(subs(v,x,interval));
            
            clf;
            subplot(2,1,1)
            fplot(dom_funct)
            grid on;
            title("Gráfica de la función en el dominio")
            xlabel("x")
            ylabel("y")
        
            subplot(2,1,2)
            plot(u1,v1)
            grid on;
            title("Gráfica de la función mapeada")
            xlabel("u")
            ylabel("v")
          
            ret_button=uicontrol('Style','pushbutton','Position',[240,5,120,20], ...
                'String', 'Regresar', 'Callback', @Map_submenu)
        
        end
    end

    function Arm_submenu(atr,~)
        clf;
        u_box=uicontrol('Style','edit','Position',[240,240,120,20],...
        'String','Ingrese u');
        v_box=uicontrol('Style', 'edit', 'Position',[240, 210, 120, 20], ...
            'String', 'Ingrese v')
        exe_button=uicontrol('Style','pushbutton','Position',[240,180,120,20],...
        'String','Ejecutar','Callback',@Armonic);
        ret_button=uicontrol('Style','pushbutton','Position',[240,60,120,20], ...
                'String', 'Regresar', 'Callback', @Practica1);

        function Armonic(atr,~)
            str1=uicontrol('Style', 'text', 'String', '', 'Position',[240 120 120 40]);
            str2=uicontrol('Style', 'text', 'String', '', 'Position',[240 90 120 20]);
            x=sym('x');
            y=sym('y');
            z=sym('z');
            u=str2sym(get(u_box,'string'));
            v=str2sym(get(v_box,'string'));

            if u == "Ingreseu"
                u=0;
            end

            if v == 'Ingresev'
                v=0;
            end

            if u ~= 0 && (diff(u,x,2)+diff(u,y,2)==0) && v ~= 0 && (diff(v,x,2)+diff(v,y,2)==0)
                dvy = diff(v,y);
                dux = diff(u,x);
                dvx = diff(v,x);
                duy = diff(u,y);

                if (dvy == dux) && (duy == -dvx)
                    set(str2, 'string', "La función es armónica");
                    fz = u + 1i*v;
                    set(str2, 'string', string(fz));

                else
                    set(str1, 'string', "La función es armónica y el conjugado v(x,y) no corresponde a u(x,y)");

                end

            elseif u ~= 0 && (diff(u,x,2)+diff(u,y,2)==0) && v == 0
                    set(str1, 'string', 'Función armónica')
                    v1=int(diff(u,x),y);
                    g=int(diff(v1,x)+diff(u,y));
                    v=v1+g;
                    f=u+1i*v;
                    f1=subs(f,{x,y},{z,0});
                    set(str2, 'string', string(f1))
                
            elseif v ~= 0 && (diff(v,x,2)+diff(v,y,2)==0) && u == 0
                    set(str1, 'string', 'Función armónica')
                    u1=int(diff(v,x),y);
                    g=int(diff(u1,x)+diff(v,y));
                    u=u1+g;
                    f=u+1i*v;
                    f1=subs(f,{x,y},{z,0});
                    set(str2, 'string', string(f1))

            else
                    set(str1, 'string', 'Función no armónica')
        
                end
            end
    end
end