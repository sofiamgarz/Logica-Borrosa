%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB Code Generated with Fuzzy Logic Designer App
%
% Date: 02-May-2025 19:34:38
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct FIS
mamdanitype1 = mamfis(Name="mamdanitype1");

% Input 1
mamdanitype1 = addInput(mamdanitype1,[0 10],Name="ToleranciaRiesgo");
mamdanitype1 = addMF(mamdanitype1,"ToleranciaRiesgo","trapmf",[0 0 1 2], ...
    Name="MuyBaja",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ToleranciaRiesgo","trapmf",[1 2 3 4], ...
    Name="Baja",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ToleranciaRiesgo","trapmf",[3 4 5 6], ...
    Name="Media",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ToleranciaRiesgo","trapmf",[5 6 7 8], ...
    Name="Alta",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ToleranciaRiesgo","trapmf",[7 8 10 10], ...
    Name="MuyAlta",VariableType="input");

% Input 2
mamdanitype1 = addInput(mamdanitype1,[0 15],Name="HorizonteInversion");
mamdanitype1 = addMF(mamdanitype1,"HorizonteInversion","trimf",[0 1 2], ...
    Name="CortoPlazo",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"HorizonteInversion","trimf",[1 4 7], ...
    Name="MedioPlazo",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"HorizonteInversion","trimf",[5 10 15], ...
    Name="LargoPlazo",VariableType="input");

% Input 3
mamdanitype1 = addInput(mamdanitype1,[0 10],Name="ConocimientoFinanciero");
mamdanitype1 = addMF(mamdanitype1,"ConocimientoFinanciero","trapmf",[0 0 2 4], ...
    Name="Limitado",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ConocimientoFinanciero","trimf",[3 5 7], ...
    Name="Medio",VariableType="input");
mamdanitype1 = addMF(mamdanitype1,"ConocimientoFinanciero","trapmf",[6 8 10 10], ...
    Name="Considerable",VariableType="input");

% Output 1
mamdanitype1 = addOutput(mamdanitype1,[0 10],Name="Estrategia");
mamdanitype1 = addMF(mamdanitype1,"Estrategia","trapmf",[0 0 3 5], ...
    Name="Conservadora",VariableType="output");
mamdanitype1 = addMF(mamdanitype1,"Estrategia","trapmf",[3 5 7 9], ...
    Name="Moderada",VariableType="output");
mamdanitype1 = addMF(mamdanitype1,"Estrategia","trapmf",[7 9 10 10], ...
    Name="Agresiva",VariableType="output");

% Rules
mamdanitype1 = addRule(mamdanitype1,[2 1 1 1 1 1; ...
    3 1 1 2 1 1; ...
    4 1 1 2 1 1; ...
    5 1 1 2 1 1; ...
    1 2 1 2 1 1; ...
    2 2 1 2 1 1; ...
    3 2 1 2 1 1; ...
    4 2 1 2 1 1; ...
    5 2 1 2 1 1; ... 
    1 3 1 1 1 1; ...
    2 3 1 1 1 1; ...
    3 3 1 2 1 1; ...
    4 3 1 2 1 1; ...
    5 3 1 2 1 1; ...
    1 1 2 1 1 1; ...
    2 1 2 1 1 1; ...
    3 1 2 2 1 1; ...
    4 1 2 2 1 1; ...
    5 1 2 3 1 1; ...
    1 2 2 1 1 1; ...
    2 2 2 1 1 1; ...
    3 2 2 2 1 1; ...
    4 2 2 3 1 1; ...
    5 2 2 3 1 1; ...
    1 3 2 1 1 1; ...
    2 3 2 1 1 1; ...
    3 3 2 2 1 1; ...
    4 3 2 3 1 1; ...
    5 3 2 3 1 1; ...
    1 1 3 2 1 1; ...
    2 1 3 2 1 1; ...
    3 1 3 3 1 1; ...
    4 1 3 3 1 1; ...
    5 1 3 3 1 1; ...
    1 2 3 2 1 1; ...
    2 2 3 2 1 1; ...
    3 2 3 3 1 1; ...
    4 2 3 3 1 1; ...
    5 2 3 3 1 1; ...
    1 3 3 2 1 1; ...
    2 3 3 2 1 1; ...
    3 3 3 3 1 1; ...
    4 3 3 3 1 1; ...
    5 3 3 3 1 1]);

% Solicitar datos al usuario
tolerancia = input('Introduce tu Tolerancia al Riesgo (0-10): ');
horizonte = input('Introduce tu Horizonte de Inversión (0-15): ');
conocimiento = input('Introduce tu Conocimiento Financiero (0-10): ');

inputValues = [tolerancia, horizonte, conocimiento];

% PASO 1: Fuzzificar las entradas (obtener grados de pertenencia)
% Calcular grados de pertenencia para Tolerancia al Riesgo
riesgoMfs = mamdanitype1.Inputs(1).MembershipFunctions;
riesgoMemberships = zeros(1, numel(riesgoMfs));
for i = 1:numel(riesgoMfs)
    riesgoMemberships(i) = feval(riesgoMfs(i).Type, inputValues(1), riesgoMfs(i).Parameters);
end
fprintf('Grados de Pertenencia - Tolerancia al Riesgo [%.1f]: (MuyBaja, Baja, Media, Alta, MuyAlta)\n', inputValues(1));
fprintf('  [%.2f, %.2f, %.2f, %.2f, %.2f]\n', riesgoMemberships);

% Calcular grados de pertenencia para Horizonte de Inversión
horizonteMfs = mamdanitype1.Inputs(2).MembershipFunctions;
horizonteMemberships = zeros(1, numel(horizonteMfs));
for i = 1:numel(horizonteMfs)
    horizonteMemberships(i) = feval(horizonteMfs(i).Type, inputValues(2), horizonteMfs(i).Parameters);
end
fprintf('Grados de Pertenencia - Horizonte de Inversión [%.1f]: (CortoPlazo, MedioPlazo, LargoPlazo)\n', inputValues(2));
fprintf('  [%.2f, %.2f, %.2f]\n', horizonteMemberships);

% Calcular grados de pertenencia para Conocimiento Financiero
conocimientoMfs = mamdanitype1.Inputs(3).MembershipFunctions;
conocimientoMemberships = zeros(1, numel(conocimientoMfs));
for i = 1:numel(conocimientoMfs)
    conocimientoMemberships(i) = feval(conocimientoMfs(i).Type, inputValues(3), conocimientoMfs(i).Parameters);
end
fprintf('Grados de Pertenencia - Conocimiento Financiero [%.1f]: (Limitado, Medio, Considerable)\n', inputValues(3));
fprintf('  [%.2f, %.2f, %.2f]\n', conocimientoMemberships);
fprintf('--------------------------------------------------\n');

% PASO 2: Evaluar la fuerza de disparo de CADA regla
fprintf('Fuerza de Disparo de las Reglas\n');
rules = mamdanitype1.Rules; % Obtener todas las reglas del FIS
numRules = numel(rules);
ruleFiringStrengths = zeros(1, numRules); % Array para guardar las fuerzas

for i = 1:numRules
    currentRule = rules(i);
    antecedentIndices = currentRule.Antecedent; % Indices de las MFs en el antecedente [idxRiesgo, idxHorizonte, idxConocimiento]
    connection = currentRule.Connection; % Operador AND (1) o OR (2)

    degrees = []; % Inicializar degrees como un vector vacío en cada iteración

    % Obtener grados de pertenencia para cada variable de entrada en la regla
    % Tolerancia al Riesgo
    if antecedentIndices(1) > 0
        degrees = [degrees, riesgoMemberships(antecedentIndices(1))];
    elseif antecedentIndices(1) < 0
        degrees = [degrees, 1 - riesgoMemberships(abs(antecedentIndices(1)))];
    end

    % Horizonte de Inversión
    if antecedentIndices(2) > 0
        degrees = [degrees, horizonteMemberships(antecedentIndices(2))];
    elseif antecedentIndices(2) < 0
        degrees = [degrees, 1 - horizonteMemberships(abs(antecedentIndices(2)))];
    end

    % Conocimiento Financiero
    if antecedentIndices(3) > 0
        degrees = [degrees, conocimientoMemberships(antecedentIndices(3))];
    elseif antecedentIndices(3) < 0
        degrees = [degrees, 1 - conocimientoMemberships(abs(antecedentIndices(3)))];
    end

    % Calcular la fuerza de disparo usando el operador de conexión
    if connection == 1 % AND (Método por defecto: min)
        if ~isempty(degrees)
            ruleFiringStrengths(i) = min(degrees);
        else
            ruleFiringStrengths(i) = 1; % Si no hay antecedentes, la fuerza es 1
        end
    elseif connection == 2 % OR (Método por defecto: max)
        if ~isempty(degrees)
            ruleFiringStrengths(i) = max(degrees);
        else
            ruleFiringStrengths(i) = 0; % Si no hay antecedentes, la fuerza es 0 (aunque esto no debería ocurrir en reglas bien definidas)
        end
    else % Conexión desconocida (no debería pasar)
        ruleFiringStrengths(i) = NaN;
    end

    % Mostrar el resultado para esta regla
    fprintf('Regla %d: %s => Fuerza = %.2f\n', i, currentRule.Description, ruleFiringStrengths(i));
end

fprintf('--------------------------------------------------\n');

% 3. Evaluación (implícita en evalfis) y 4. Desborrosificación
[outputValue, ~, ~, AggregatedOutput] = evalfis(mamdanitype1, inputValues);

% Mostrar el resultado en la Command Window
disp(['La estrategia de inversión recomendada (valor desborrosificado) es: ', num2str(outputValue)]);
fprintf('Se le recomienda la siguiente estrategia de inversión: ');
if outputValue > 7
    fprintf('Agresiva\n');
elseif outputValue > 5
    fprintf('Moderada\n');
else
    fprintf('Conservadora\n');
end

% VISUALIZACIÓN DETALLADA
close all;%me da error sin esto
figure;
hold on;

% Obtener la variable de salida
outputVar = mamdanitype1.Outputs(1);
x_eval_range = linspace(outputVar.Range(1), outputVar.Range(2), length(AggregatedOutput));
x_plot_range = linspace(outputVar.Range(1), outputVar.Range(2), 201);
outputMFs = outputVar.MembershipFunctions;
mfColors = lines(numel(outputMFs));

% Graficar las funciones de pertenencia de salida originales
for i = 1:numel(outputMFs)
    y_mf = feval(outputMFs(i).Type, x_plot_range, outputMFs(i).Parameters);
    plot(x_plot_range, y_mf, '--', 'Color', [mfColors(i,:), 0.8], 'LineWidth', 1);
end

% Graficar y rellenar la salida agregada
plot(x_eval_range, AggregatedOutput, 'b-', 'LineWidth', 2);
fill(x_eval_range, AggregatedOutput, 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Graficar la línea del centroide
line([outputValue outputValue], [0 max(AggregatedOutput)*1.05], ...
    'Color', 'r', 'LineWidth', 1.5, 'LineStyle', '-.');

% Añadir texto con el valor del centroide
text(outputValue, -0.05 * max(1,max(AggregatedOutput)), ...
    sprintf('%.2f', outputValue), ...
    'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');

% Etiquetas y título
xlabel(['Salida: ', outputVar.Name]);
ylabel('\mu (Grado de Pertenencia)');
title('Visualización de la Defuzzificación (Método Centroide)');
ylim([-0.1*max(1,max(AggregatedOutput)) max(1,max(AggregatedOutput))*1.1]);
xlim(outputVar.Range);
grid on;

% Crear leyenda
legendEntries = {outputMFs.Name, 'Salida Agregada', sprintf('Centroide (%.2f)', outputValue)};
legend(legendEntries, 'Location', 'northeast');

hold off;