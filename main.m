% Función principal
function mapeao1(atr, ~)
    % Crea la figura
    fig = uifigure('Name', 'Mapeo y Funciones Armónicas', 'Color', [0.15 0.15 0.15]);
    
    % Crea los botones de la interfaz
    map_button = uibutton(fig, 'push', 'Position', [240, 210, 120, 20], ...
        'Text', 'Mapeo de funciones', 'ButtonPushedFcn', @Map_submenu, 'BackgroundColor', [0.3 0.75 0.93]);
    arm_button = uibutton(fig, 'push', 'Position', [240, 180, 120, 20], ...
        'Text', 'Funciones armónicas', 'ButtonPushedFcn', @Arm_submenu, 'BackgroundColor', [0.3 0.75 0.93]);

    % Submenú de mapeo
    function Map_submenu(atr, ~)
        % Crea los campos de texto y botones de la interfaz
        dom_box = uieditfield(fig, 'Position', [240, 240, 120, 20], ...
            'Placeholder', 'ingrese dominio', 'FontColor', 'white', 'BackgroundColor', [0.25 0.25 0.25]);
        map_box = uieditfield(fig, 'Position', [240, 210, 120, 20], ...
            'Placeholder', 'ingrese mapeo', 'FontColor', 'white', 'BackgroundColor', [0.25 0.25 0.25]);
        interval_box = uieditfield(fig, 'Position', [240, 180, 120, 20], ...
            'Placeholder', 'ingrese intervalo', 'FontColor', 'white', 'BackgroundColor', [0.25 0.25 0.25]);
        exe_button = uibutton(fig, 'push', 'Position', [240, 150, 120, 20], ...
            'Text', 'Ejecutar', 'ButtonPushedFcn', @Mapeo, 'BackgroundColor', [0.3 0.75 0.93]);
        ret_button = uibutton(fig, 'push', 'Position', [240, 120, 120, 20], ...
            'Text', 'Regresar', 'ButtonPushedFcn', @mapeao1, 'BackgroundColor', [0.3 0.75 0.93]);

        % Función de mapeo
        function Mapeo(atr, ~)
            % Define las variables simbólicas
            x = sym('x');
            y = sym('y');
            z = sym('z');
            
            % Obtiene las funciones del usuario
            dom_funct = str2sym(dom_box.Value);
            map_funct = str2sym(map_box.Value);
            
            % Realiza el mapeo
            f1 = subs(map_funct, z, x + 1i * y);
            f2 = subs(f1, y, dom_funct);
            u = real(f2);
            v = imag(f2);
            
            % Obtiene el intervalo del usuario
            interval = str2num(interval_box.Value);
            
            % Sustituye el intervalo en las funciones
            u1 = subs(u, x, interval);
            v1 = subs(v, x, interval);
            
            % Grafica la función en el dominio
            subplot(2, 1, 1);
            fplot(dom_funct);
            grid on;
            title('Gráfica de la función en el dominio');
            xlabel('x');
            ylabel('y');
            
            % Grafica la función mapeada
            subplot(2, 1, 2);
            plot(u1, v1);
            grid on;
            title('Gráfica de la función mapeada');
            xlabel('u');
            ylabel('v');
            
            % Crea el botón de regreso
            ret_button = uibutton(fig, 'push', 'Position', [240, 5, 120, 20], ...
                'Text', 'Limpiar', 'ButtonPushedFcn', @Map_submenu, 'BackgroundColor', [0.3 0.75 0.93]);
        end
    end

% Submenú de funciones armónicas
function Arm_submenu(atr, ~)
    % Crea una nueva figura
    fig2 = uifigure('Name', 'Funciones Armónicas', 'Color', [0.15 0.15 0.15]);
    
    % Crea los campos de texto y botones de la interfaz
    funcion_u = uieditfield(fig2, 'Position', [200 289 261 31], ...
        'FontName', 'Artifakt Element', 'FontSize', 10, 'Placeholder', 'Funcion u(x,y)', ...
        'HorizontalAlignment', 'center', 'FontColor', 'white', 'BackgroundColor', [0.25 0.25 0.25]);
    funcion_v = uieditfield(fig2, 'Position', [200 239 261 31], ...
        'FontName', 'Artifakt Element', 'FontSize', 10, 'Placeholder', 'Funcion v(x,y)', ...
        'HorizontalAlignment', 'center', 'FontColor', 'white', 'BackgroundColor', [0.25 0.25 0.25]);
    campo_armonico = uitextarea(fig2, 'Value', 'Resultado evaluación armónico', ...
        'Position', [200 189 261 51], 'BackgroundColor', [0.25 0.25 0.25], 'FontName', 'Artifakt Element', ...
        'FontSize', 12, 'Editable', 'off', 'HorizontalAlignment', 'center', 'FontColor', 'white');
    campo_fz = uitextarea(fig2, 'Value', 'Función f(z)', ...
        'Position', [200 138 261 38], 'BackgroundColor', [0.25 0.25 0.25], 'FontName', 'Artifakt Element', ...
        'FontSize', 12, 'Editable', 'off', 'HorizontalAlignment', 'center', 'FontColor', 'white');
    boton_evaluar = uibutton(fig2, 'push', 'Text', 'Evaluar', ...
        'Position', [300 98 69 28], 'FontName', 'Artifakt Element', 'FontSize', 10, ...
        'ButtonPushedFcn', @(src, event) armonico(), 'BackgroundColor', [0.3 0.75 0.93]);
    ret_button = uibutton(fig2, 'push', 'Position', [300 58 120 20], ...
        'Text', 'Regresar', 'ButtonPushedFcn', @(src, event) close(fig2), 'BackgroundColor', [0.3 0.75 0.93]);

        % Función de armónicas
        function armonico()
            x = sym('x');
            y = sym('y');
            z = sym('z');
            k = sym('k');
            
            if isempty(funcion_v.Value) && (isempty(funcion_u.Value) == 0)
                u = str2sym(funcion_u.Value);
                d2u = diff(u, x, 2) + diff(u, y, 2);
                if d2u == 0
                    campo_armonico.Value = "La función es armónica";
                    dvy = diff(u, x);
                    v = int(dvy, y);
                    dvx = diff(v, x);
                    duy = diff(u, y);
                    if dvx == -duy
                        gx = k;
                    else
                        gx = int(-diff(u, y), x);
                    end
                    v1 = v + gx;
                    funcion_v.Value = string(v1);
                    fz = u + j * (v1);
                    campo_fz.Value = string(fz);
                else
                    campo_armonico.Value = "La función NO es armónica";
                    campo_fz.Value = "";
                end

            elseif isempty(funcion_u.Value) && (isempty(funcion_v.Value) == 0)
                v = str2sym(funcion_v.Value);
                d2v = diff(v, x, 2) + diff(v, y, 2);
                if d2v == 0
                    campo_armonico.Value = "La función es armónica";
                    ux = diff(v, y);
                    u = int(ux, x);
                    funcion_u.Value = string(u);
                    fz = u + j * v;
                    campo_fz.Value = string(fz);
                else
                    campo_armonico.Value = "La función NO es armónica";
                    campo_fz.Value = "";
                end
            
            elseif (isempty(funcion_u.Value) == 0) && (isempty(funcion_v.Value) == 0)
                u = str2sym(funcion_u.Value);
                v = str2sym(funcion_v.Value);
                d2u = diff(u, x, 2) + diff(u, y, 2);
                if d2u == 0
                    dvy = diff(v, y);
                    dux = diff(u, x);
                    dvx = diff(v, x);
                    duy = diff(u, y);
                    if (dvy == dux) && (duy == -dvx)
                        campo_armonico.Value = "La función es armónica";
                        fz = u + j * v;
                        campo_fz.Value = string(fz);
                    else
                        linea_texto = sprintf("%s\n%s", "La función es armónica", "El conjugado v(x,y) no corresponde a u(x,y)");
                        campo_armonico.Value = linea_texto;
                        campo_fz.Value = "";
                    end
                else
                    campo_armonico.Value = "La función NO es armónica";
                    campo_fz.Value = "";
                end

            else
                campo_fz.Value = "Debe ingresar una función";
                campo_armonico.Value = "Debe ingresar una función";
            end
        end
    end
end
