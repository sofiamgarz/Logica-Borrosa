%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Code Generated with Fuzzy Logic Designer App                    
% Using User's Original Parameters                   
% Date: 02-May-2025 17:02:18                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear mamdanitype1; % Clear previous version

% Construimos el sistema
mamdanitype1 = mamfis(Name="mamdanitype1"); 

% Variable de entrada 1 (Temperatura del Aire)
mamdanitype1 = addInput(mamdanitype1,[0 50],Name="Temperatura");
mamdanitype1 = addMF(mamdanitype1,"Temperatura","trapmf",[0 0 7.94 15.28], Name="Congelado");
mamdanitype1 = addMF(mamdanitype1,"Temperatura","trimf",[6.1 12.83 18.3], Name="Frío");
mamdanitype1 = addMF(mamdanitype1,"Temperatura","trimf",[12.83 18.3 23.83], Name="Normal");
mamdanitype1 = addMF(mamdanitype1,"Temperatura","trimf",[20.17 25.67 34.2], Name="Tibio"); % Original
mamdanitype1 = addMF(mamdanitype1,"Temperatura","trapmf",[28.72 39.72 43.39 44], Name="Caliente"); % Original (adjusted upper range to 44 for consistency)

% Variable de entrada 2 (Humedad del suelo)
mamdanitype1 = addInput(mamdanitype1,[0 100],Name="Humedad"); % Original range was [0 50]
mamdanitype1 = addMF(mamdanitype1,"Humedad","trapmf",[0 0 7.174 12.435], Name="Seca"); % Original
mamdanitype1 = addMF(mamdanitype1,"Humedad","trapmf",[7.174 12.345 16.74 19.61], Name="Húmeda"); % Original
mamdanitype1 = addMF(mamdanitype1,"Humedad","trapmf",[14.83 22.9565 27.74 27.74], Name="Mojada"); % Original (adjusted range max slightly if needed based on MFs)



% Variable de salida (Tiempo de Regadíp)
mamdanitype1 = addOutput(mamdanitype1,[0 60],Name="Tiempo");
mamdanitype1 = addMF(mamdanitype1,"Tiempo","trapmf",[0 0 7.5 15], Name="Corto");
mamdanitype1 = addMF(mamdanitype1,"Tiempo","trapmf",[15 20 25 30], Name="Medio");
mamdanitype1 = addMF(mamdanitype1,"Tiempo","trapmf",[30 40 60 60], Name="Prolongado");

% Reglas de Evaluacion
ruleList = [ ...
    % Humedad = Seca 
    1 1 3 1 1; 2 1 3 1 1; 3 1 3 1 1; 4 1 3 1 1; 5 1 3 1 1;
    % Humedad = Húmeda 
    1 2 1 1 1; 2 2 2 1 1; 3 2 2 1 1; 4 2 2 1 1; 5 2 2 1 1;
    % Humedad = Mojada 
    1 3 1 1 1; 2 3 1 1 1; 3 3 1 1 1; 4 3 1 1 1; 5 3 1 1 1;
];

mamdanitype1 = addRule(mamdanitype1, ruleList);


%Test: Valores del documento 
inputValues = [33 11]; % Temperatura = 33, Humedad = 11

outputValue = evalfis(mamdanitype1, inputValues);

% Mostramos la salida abrupta final
fprintf('El valor de salida calculado (Tiempo)con los parámetros establecidos es: %.2f minutos\n', outputValue);
fprintf('Valor del documento (esperado/teórico): 38 minutos\n');

% Visualizacion de resultados
  fuzzyLogicDesigner(mamdanitype1);
  figure; gensurf(mamdanitype1); title('Input/Output Surface (Original Parameters)');




% --- PASO 1: Fuzzificar las entradas (obtener grados de pertenencia) ---
% Calcular grados de pertenencia para Temperatura
tempMfs = mamdanitype1.Inputs(1).MembershipFunctions;
tempMemberships = zeros(1, numel(tempMfs));
for i = 1:numel(tempMfs)
    % Usar feval con el tipo de función y los parámetros almacenados
    tempMemberships(i) = feval(tempMfs(i).Type, inputValues(1), tempMfs(i).Parameters);
end
fprintf('Grados de Pertenencia - Temperatura [%.1f]: (Cong, Fri, Nor, Tib, Cal)\n', inputValues(1));
fprintf('   [%.2f, %.2f, %.2f, %.2f, %.2f]\n', tempMemberships);

% Calcular grados de pertenencia para Humedad
humMfs = mamdanitype1.Inputs(2).MembershipFunctions;
humMemberships = zeros(1, numel(humMfs));
for i = 1:numel(humMfs)
    humMemberships(i) = feval(humMfs(i).Type, inputValues(2), humMfs(i).Parameters);
end
fprintf('Grados de Pertenencia - Humedad [%.1f]: (Seca, Hum, Moj)\n', inputValues(2));
fprintf('   [%.2f, %.2f, %.2f]\n', humMemberships);
fprintf('--------------------------------------------------\n');

% --- PASO 2: Evaluar la fuerza de disparo de CADA regla ---
fprintf('--- Fuerza de Disparo de las Reglas ---\n');
rules = mamdanitype1.Rules; % Obtener todas las reglas del FIS

ruleFiringStrengths = zeros(1, numel(rules)); % Array para guardar las fuerzas

for i = 1:numel(rules)
    currentRule = rules(i);
    antecedentIndices = currentRule.Antecedent; % Indices de las MFs en el antecedente
                                                % ej: [idxTemp, idxHum]
    connection = currentRule.Connection; % Operador AND (1) o OR (2)

    % Obtener los grados de pertenencia relevantes para esta regla
    % Índice 1 es Temperatura, Índice 2 es Humedad
    degreeTemp = 1.0; % Valor por defecto si la entrada no se usa
    if antecedentIndices(1) > 0 % Si se usa Temp y no es NOT
        degreeTemp = tempMemberships(antecedentIndices(1));
    elseif antecedentIndices(1) < 0 % Si se usa Temp y es NOT
         degreeTemp = 1 - tempMemberships(abs(antecedentIndices(1)));
    end % Si es 0, se ignora (valor 1.0 no afecta a MIN)

    degreeHum = 1.0; % Valor por defecto si la entrada no se usa
    if antecedentIndices(2) > 0 % Si se usa Hum y no es NOT
        degreeHum = humMemberships(antecedentIndices(2));
    elseif antecedentIndices(2) < 0 % Si se usa Hum y es NOT
         degreeHum = 1 - humMemberships(abs(antecedentIndices(2)));
    end % Si es 0, se ignora

    % Calcular la fuerza de disparo usando el operador de conexión
    if connection == 1 % AND (Método por defecto: min)
        ruleFiringStrengths(i) = min(degreeTemp, degreeHum);
    elseif connection == 2 % OR (Método por defecto: max)
        ruleFiringStrengths(i) = max(degreeTemp, degreeHum);
    else % Conexión desconocida (no debería pasar)
        ruleFiringStrengths(i) = NaN;
    end

    % Mostrar el resultado para esta regla
    fprintf('Regla %d: %s => Fuerza = %.2f\n', i, currentRule.Description, ruleFiringStrengths(i));
end

fprintf('--------------------------------------------------\n');

%Graficos finales

% Evaluar el FIS para obtener el valor final Y la salida agregada
% [salida_final, ~, ~, SALIDA_AGREGADA] = evalfis(FIS, entradas);
[outputValue, ~, ~, AggregatedOutput] = evalfis(mamdanitype1, inputValues);

% Determinar la resolución utilizada por evalfis
numReturnedPoints = length(AggregatedOutput);
fprintf('evalfis devolvió la salida agregada con %d puntos.\n', numReturnedPoints);

% Crear el eje X para la gráfica BASADO EN la salida de evalfis
outputVar = mamdanitype1.Outputs(1); % Obtener la variable de salida
x_eval_range = linspace(outputVar.Range(1), outputVar.Range(2), numReturnedPoints); % Eje X que coincide con AggregatedOutput

numPlotPoints = 201; 
x_plot_range = linspace(outputVar.Range(1), outputVar.Range(2), numPlotPoints);

% Crear la Figura
figure;
hold on; 

% 1. Graficar las Funciones de Pertenencia de SALIDA ORIGINALES 
outputMFs = outputVar.MembershipFunctions;
mfHandles = gobjects(1, numel(outputMFs)); % Para la leyenda
mfColors = lines(numel(outputMFs)); % Colores distintos para cada MF
for i = 1:numel(outputMFs)
    mfName = outputMFs(i).Name;
    mfParams = outputMFs(i).Parameters;
    mfType = outputMFs(i).Type;
    % Calcular los valores Y de la MF sobre el rango
    y_mf = feval(mfType, x_plot_range, mfParams);
    % Graficar la MF original 
    mfHandles(i) = plot(x_plot_range, y_mf, '--', 'Color', [mfColors(i,:), 0.8], 'LineWidth', 1);
end

% 2. Graficar el Conjunto Difuso de SALIDA AGREGADO
% Usar el x_eval_range que coincide con AggregatedOutput
h_agg = plot(x_eval_range, AggregatedOutput, 'b-', 'LineWidth', 2);

% 3. Rellenar el Área Bajo la Curva Agregada
% Usar el x_eval_range que coincide con AggregatedOutput
fill(x_eval_range, AggregatedOutput, 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); 

% 4. Dibujar la Línea Vertical del Centroide (Valor Defuzzificado)
h_centroid = line([outputValue outputValue], [0 max(AggregatedOutput)*1.05], ...
                  'Color', 'r', 'LineWidth', 1.5, 'LineStyle', '-.');

% 5. Añadir Texto con el Valor del Centroide
text(outputValue, -0.05 * max(1,max(AggregatedOutput)), ... 
     sprintf('%.2f', outputValue), ...
     'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');

% 6. Añadir Líneas Horizontales de Referencia 
% Ejemplo usando valores fijos del documento:
rule_strength_1_3 = 0.27; % Corresponde a Prolongado (Reglas 1 y 3)
rule_strength_2_4 = 0.39; % Corresponde a Medio (Reglas 2 y 4)
% Estos valores determinan la altura a la que se 'cortan' las MFs de salida
% antes de la agregación con 'max'. El pico de AggregatedOutput debería ser
% max(rule_strength_1_3, rule_strength_2_4) = 0.46 en este caso.

line(outputVar.Range, [rule_strength_1_3 rule_strength_1_3], 'Color', [0.5 0.5 0.5], 'LineStyle', ':');
line(outputVar.Range, [rule_strength_2_4 rule_strength_2_4], 'Color', [0.5 0.5 0.5], 'LineStyle', ':');
text(outputVar.Range(1) - diff(outputVar.Range)*0.01, rule_strength_1_3, sprintf('%.2f', rule_strength_1_3), 'HorizontalAlignment', 'right','Color',[0.5 0.5 0.5]);
text(outputVar.Range(1) - diff(outputVar.Range)*0.01, rule_strength_2_4, sprintf('%.2f', rule_strength_2_4), 'HorizontalAlignment', 'right','Color',[0.5 0.5 0.5]);


%7. Títulos, Etiquetas y Leyenda
xlabel(['Salida: ', outputVar.Name, ' (min)']);
ylabel('\mu (Grado de Pertenencia)');
title('Visualización de la Defuzzificación (Método Centroide)');
ylim([-0.1*max(1,max(AggregatedOutput)) max(1,max(AggregatedOutput))*1.1]); % Ajustar límites Y dinámicamente
xlim(outputVar.Range);
grid on;

% Crear leyenda
legendEntries = {outputMFs.Name}; % Nombres MFs originales
legendHandles = mfHandles;
legendEntries{end+1} = 'Salida Agregada';
legendHandles(end+1) = h_agg;
legendEntries{end+1} = sprintf('Centroide (%.2f)', outputValue);
legendHandles(end+1) = h_centroid;
legend(legendHandles, legendEntries, 'Location', 'northeast');

hold off; 