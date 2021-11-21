classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Image                          matlab.ui.control.Image
        CalcularButton                 matlab.ui.control.Button
        minL                           matlab.ui.control.NumericEditField
        IngreselalongituddeondamnimanmLabel  matlab.ui.control.Label
        IngreselalongituddeondamximanmLabel  matlab.ui.control.Label
        maxL                           matlab.ui.control.NumericEditField
        IngreselaresolucinLabel        matlab.ui.control.Label
        resolucion                     matlab.ui.control.NumericEditField
        IngreseladeflexiongradosLabel  matlab.ui.control.Label
        phi                            matlab.ui.control.NumericEditField
        Ingreseladensidadderejillas1mmLabel  matlab.ui.control.Label
        G                              matlab.ui.control.NumericEditField
        IngreseelanchodeldetectormmLabel  matlab.ui.control.Label
        LD                             matlab.ui.control.NumericEditField
        IngreselamagnificacinLabel     matlab.ui.control.Label
        M                              matlab.ui.control.NumericEditField
        AnchodelahendiduraumLabel      matlab.ui.control.Label
        AnchoSalida                    matlab.ui.control.NumericEditField
        LongitudfocaldelcolimadormmLabel  matlab.ui.control.Label
        ColimadorSalida                matlab.ui.control.NumericEditField
        EnfoquedelalongitudfocalmmLabel  matlab.ui.control.Label
        FocalSalida_2                  matlab.ui.control.NumericEditField
        ngulodedeflexingradosLabel     matlab.ui.control.Label
        deflexionsalida                matlab.ui.control.NumericEditField
        IngreselaaperturanumricaLabel  matlab.ui.control.Label
        AN                             matlab.ui.control.NumericEditField
        DimetrolentefocalmmlLabel      matlab.ui.control.Label
        DimetrolentecolimadormmLabel   matlab.ui.control.Label
        DiaFSalida                     matlab.ui.control.NumericEditField
        DiaCSalida                     matlab.ui.control.NumericEditField
        NmerodepxelesLabel             matlab.ui.control.Label
        TamaodepxeumlLabel             matlab.ui.control.Label
        NumPSalida                     matlab.ui.control.NumericEditField
        TamPSalida                     matlab.ui.control.NumericEditField
        DimensionesButton              matlab.ui.control.Button
        Label                          matlab.ui.control.Label
        DiseadordelespectrmetroCzernyTurnerLabel  matlab.ui.control.Label
        Image2                         matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcularButton
        function CalcularButtonPushed(app, event)
           global LC LF;
            minLV=app.minL.Value;
            
            maxLV=app.maxL.Value;
            NumA=app.AN.Value;
            phiV=app.phi.Value*pi/180;
            GV=app.G.Value;
            deltaLambda=(minLV+maxLV)/2;
            alpha=asin(deltaLambda*GV/(2*10^6*cos(phiV/2)))-phiV/2;
            betaV=phiV-alpha;
            MV=app.M.Value;
            LDV=app.LD.Value;
            LF=LDV*cos(betaV)/(GV*(maxLV-minLV))*10^6;%Longitud focal
            resolucionV=app.resolucion.Value;
            LC=LF*cos(alpha)/(MV*cos(betaV));%Longitud colimador
        wslit=GV*resolucionV*LC*10^-3/cos(alpha);
        %Las ultimas 4 salidas
        TheA=asin(NumA);
        DiaF=atan(TheA)*2*LF;
        DiaC=atan(TheA)*2*LC;
        NumP=(maxLV-minLV)/resolucionV;
        TamP=LDV/NumP*10^3;
        
        if(wslit<10) 
            msgbox("Se debe de cambiar el valor de el ancho del detector(1)," + ...
                "  la resolucion(2)  o una mayor densidad de la rejilla(3) ya que el" + ...
                "ancho de la hendidura no puede ser menor a 10um","Error");
         %%%%%%%%%%IMPRIMIMOS LOS DATOS%%%%             
                      app.AnchoSalida.Value=0;
            app.ColimadorSalida.Value=0;
            app.FocalSalida_2.Value=0;
            app.deflexionsalida.Value=0;
                    
            app.DiaFSalida.Value=0;
            app.DiaCSalida.Value=0;
            app.NumPSalida.Value=0;
            app.TamPSalida.Value=0;
        
        else         
             app.AnchoSalida.Value=wslit;
            app.ColimadorSalida.Value=LC;
            app.FocalSalida_2.Value=LF;
            app.deflexionsalida.Value=betaV*180/pi;
            
            app.DiaFSalida.Value=DiaF;
            app.DiaCSalida.Value=DiaC;
            app.NumPSalida.Value=NumP;
            app.TamPSalida.Value=TamP;
            
            %Primera Grafica
              Lmax=minLV;
              Resol=[];
              i=1;
              while Lmax<=maxLV
                  LamcR=(minLV+Lmax)/2;
                  DelR=Lmax-minLV;
                   Resol(i)=1.028*(LamcR*MV*DelR)*10^(-6)/(2*LDV*tan(TheA));
                  i=i+1;
                  Lmax=Lmax+0.1;
              end
              L=(maxLV-minLV)/(i-2);
              ArrayLma=[minLV:L:maxLV];
              clear figure;
              plot(ArrayLma, Resol);
              grid on;
              xlabel("\lambda(nm)","Interpreter","tex")
              ylabel("FWHM","Interpreter","tex")    
            title("Límite de difracción de la óptica")
            
            %Segunda grafica
            Lmax=minLV;
              ResolG=[];
              i=1;
              while Lmax<=maxLV
                  LamcR=(minLV+Lmax)/2;
                  AlphaG=asin(LamcR*GV/(2*10^6*cos(phiV/2)))-phiV/2;
                  BethaG=phiV-AlphaG;
                  LcG= (LDV*cos(BethaG)*10^6/(GV*(Lmax-minLV)) )*cos(AlphaG)/(MV*cos(BethaG));
                  ResolG(i)=0.84*LamcR*cos(AlphaG)/(2*GV*LcG*atan(TheA));
                  i=i+1;
                  Lmax=Lmax+0.1;
              end
              L=(maxLV-minLV)/(i-2);
              ArrayLmaG=[minLV:L:maxLV];
              figure;
            plot(ArrayLmaG,ResolG);
            xlabel("\lambda(nm)","Interpreter","tex")
            ylabel("FWHM","Interpreter","tex")    
            title("Límite de difracción de la rejilla")
              grid on;
              
            
        end

        if LC>40 || LF>40
            msgbox("Las distancias focales son muy grandes","Error");
            
            
        end
   
        
           
            
        end

        % Callback function
        function UIAxes2ButtonDown(app, event)
            
        end

        % Button pushed function: DimensionesButton
        function DimensionesButtonPushed(app, event)
                        minLV=app.minL.Value;
            maxLV=app.maxL.Value;
            NumA=app.AN.Value;
            phiV=app.phi.Value*pi/180;
            GV=app.G.Value;
            deltaLambda=(minLV+maxLV)/2;
            alpha=asin(deltaLambda*GV/(2*10^6*cos(phiV/2)))-phiV/2;
            betaV=phiV-alpha;
            MV=app.M.Value;
            LDV=app.LD.Value;
            LF=LDV*cos(betaV)/(GV*(maxLV-minLV))*10^6;%Longitud focal
            resolucionV=app.resolucion.Value;
            LC=LF*cos(alpha)/(MV*cos(betaV));%Longitud colimador
        wslit=GV*resolucionV*LC*10^-3/cos(alpha);
        %Las ultimas 4 salidas
        TheA=asin(NumA);
        DiaF=atan(TheA)*2*LF;
        DiaC=atan(TheA)*2*LC;
        NumP=(maxLV-minLV)/resolucionV;
        TamP=LDV/NumP*10^3;
            
            
                       global LC LF;

            
            LargoS=3*LC;
            AnchoS=2*LF;
            app.Label.Text="Las longitudes serán: "+num2str(LargoS)+"mm y "+num2str(AnchoS)+"mm";
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 766 502];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [1 -40 758 585];
            app.Image.ImageSource = 'fondo.jpg';

            % Create CalcularButton
            app.CalcularButton = uibutton(app.UIFigure, 'push');
            app.CalcularButton.ButtonPushedFcn = createCallbackFcn(app, @CalcularButtonPushed, true);
            app.CalcularButton.Position = [270 47 100 22];
            app.CalcularButton.Text = 'Calcular';

            % Create minL
            app.minL = uieditfield(app.UIFigure, 'numeric');
            app.minL.Position = [242 419 100 22];
            app.minL.Value = 150;

            % Create IngreselalongituddeondamnimanmLabel
            app.IngreselalongituddeondamnimanmLabel = uilabel(app.UIFigure);
            app.IngreselalongituddeondamnimanmLabel.FontColor = [1 1 1];
            app.IngreselalongituddeondamnimanmLabel.Position = [21 419 222 22];
            app.IngreselalongituddeondamnimanmLabel.Text = 'Ingrese la longitud de onda mínima(nm):';

            % Create IngreselalongituddeondamximanmLabel
            app.IngreselalongituddeondamximanmLabel = uilabel(app.UIFigure);
            app.IngreselalongituddeondamximanmLabel.FontColor = [1 1 1];
            app.IngreselalongituddeondamximanmLabel.Position = [21 381 226 22];
            app.IngreselalongituddeondamximanmLabel.Text = 'Ingrese la longitud de onda máxima(nm):';

            % Create maxL
            app.maxL = uieditfield(app.UIFigure, 'numeric');
            app.maxL.Position = [242 381 100 22];
            app.maxL.Value = 200;

            % Create IngreselaresolucinLabel
            app.IngreselaresolucinLabel = uilabel(app.UIFigure);
            app.IngreselaresolucinLabel.FontColor = [1 1 1];
            app.IngreselaresolucinLabel.Position = [21 345 120 22];
            app.IngreselaresolucinLabel.Text = 'Ingrese la resolución:';

            % Create resolucion
            app.resolucion = uieditfield(app.UIFigure, 'numeric');
            app.resolucion.Position = [242 345 100 22];
            app.resolucion.Value = 1;

            % Create IngreseladeflexiongradosLabel
            app.IngreseladeflexiongradosLabel = uilabel(app.UIFigure);
            app.IngreseladeflexiongradosLabel.FontColor = [1 1 1];
            app.IngreseladeflexiongradosLabel.Position = [21 304 158 22];
            app.IngreseladeflexiongradosLabel.Text = 'Ingrese la deflexion(grados):';

            % Create phi
            app.phi = uieditfield(app.UIFigure, 'numeric');
            app.phi.Position = [242 304 100 22];
            app.phi.Value = 1;

            % Create Ingreseladensidadderejillas1mmLabel
            app.Ingreseladensidadderejillas1mmLabel = uilabel(app.UIFigure);
            app.Ingreseladensidadderejillas1mmLabel.FontColor = [1 1 1];
            app.Ingreseladensidadderejillas1mmLabel.Position = [21 267 207 22];
            app.Ingreseladensidadderejillas1mmLabel.Text = 'Ingrese la densidad de rejillas(1/mm):';

            % Create G
            app.G = uieditfield(app.UIFigure, 'numeric');
            app.G.Position = [242 267 100 22];
            app.G.Value = 12;

            % Create IngreseelanchodeldetectormmLabel
            app.IngreseelanchodeldetectormmLabel = uilabel(app.UIFigure);
            app.IngreseelanchodeldetectormmLabel.FontColor = [1 1 1];
            app.IngreseelanchodeldetectormmLabel.Position = [21 232 193 22];
            app.IngreseelanchodeldetectormmLabel.Text = 'Ingrese el ancho del detector(mm):';

            % Create LD
            app.LD = uieditfield(app.UIFigure, 'numeric');
            app.LD.Position = [242 232 100 22];
            app.LD.Value = 1;

            % Create IngreselamagnificacinLabel
            app.IngreselamagnificacinLabel = uilabel(app.UIFigure);
            app.IngreselamagnificacinLabel.FontColor = [1 1 1];
            app.IngreselamagnificacinLabel.Position = [21 200 138 22];
            app.IngreselamagnificacinLabel.Text = 'Ingrese la magnificación:';

            % Create M
            app.M = uieditfield(app.UIFigure, 'numeric');
            app.M.Position = [242 200 100 22];
            app.M.Value = 1;

            % Create AnchodelahendiduraumLabel
            app.AnchodelahendiduraumLabel = uilabel(app.UIFigure);
            app.AnchodelahendiduraumLabel.FontColor = [1 1 1];
            app.AnchodelahendiduraumLabel.Position = [369 419 154 22];
            app.AnchodelahendiduraumLabel.Text = 'Ancho de la hendidura(um):';

            % Create AnchoSalida
            app.AnchoSalida = uieditfield(app.UIFigure, 'numeric');
            app.AnchoSalida.Position = [548 419 100 22];

            % Create LongitudfocaldelcolimadormmLabel
            app.LongitudfocaldelcolimadormmLabel = uilabel(app.UIFigure);
            app.LongitudfocaldelcolimadormmLabel.FontColor = [1 1 1];
            app.LongitudfocaldelcolimadormmLabel.Position = [369 381 186 22];
            app.LongitudfocaldelcolimadormmLabel.Text = 'Longitud focal del colimador(mm):';

            % Create ColimadorSalida
            app.ColimadorSalida = uieditfield(app.UIFigure, 'numeric');
            app.ColimadorSalida.Position = [548 381 100 22];

            % Create EnfoquedelalongitudfocalmmLabel
            app.EnfoquedelalongitudfocalmmLabel = uilabel(app.UIFigure);
            app.EnfoquedelalongitudfocalmmLabel.FontColor = [1 1 1];
            app.EnfoquedelalongitudfocalmmLabel.Position = [369 345 188 22];
            app.EnfoquedelalongitudfocalmmLabel.Text = 'Enfoque de la longitud focal(mm): ';

            % Create FocalSalida_2
            app.FocalSalida_2 = uieditfield(app.UIFigure, 'numeric');
            app.FocalSalida_2.Position = [548 345 100 22];

            % Create ngulodedeflexingradosLabel
            app.ngulodedeflexingradosLabel = uilabel(app.UIFigure);
            app.ngulodedeflexingradosLabel.FontColor = [1 1 1];
            app.ngulodedeflexingradosLabel.Position = [369 304 159 22];
            app.ngulodedeflexingradosLabel.Text = 'Ángulo de deflexión(grados):';

            % Create deflexionsalida
            app.deflexionsalida = uieditfield(app.UIFigure, 'numeric');
            app.deflexionsalida.Position = [548 304 100 22];

            % Create IngreselaaperturanumricaLabel
            app.IngreselaaperturanumricaLabel = uilabel(app.UIFigure);
            app.IngreselaaperturanumricaLabel.FontColor = [1 1 1];
            app.IngreselaaperturanumricaLabel.Position = [21 164 162 22];
            app.IngreselaaperturanumricaLabel.Text = 'Ingrese la apertura numérica:';

            % Create AN
            app.AN = uieditfield(app.UIFigure, 'numeric');
            app.AN.Position = [242 164 100 22];
            app.AN.Value = 1;

            % Create DimetrolentefocalmmlLabel
            app.DimetrolentefocalmmlLabel = uilabel(app.UIFigure);
            app.DimetrolentefocalmmlLabel.FontColor = [1 1 1];
            app.DimetrolentefocalmmlLabel.Position = [369 267 146 22];
            app.DimetrolentefocalmmlLabel.Text = 'Diámetro lente focal(mm)l:';

            % Create DimetrolentecolimadormmLabel
            app.DimetrolentecolimadormmLabel = uilabel(app.UIFigure);
            app.DimetrolentecolimadormmLabel.FontColor = [1 1 1];
            app.DimetrolentecolimadormmLabel.Position = [369 232 170 22];
            app.DimetrolentecolimadormmLabel.Text = {'Diámetro lente colimador(mm):'; ''};

            % Create DiaFSalida
            app.DiaFSalida = uieditfield(app.UIFigure, 'numeric');
            app.DiaFSalida.Position = [548 267 100 22];

            % Create DiaCSalida
            app.DiaCSalida = uieditfield(app.UIFigure, 'numeric');
            app.DiaCSalida.Position = [548 232 100 22];

            % Create NmerodepxelesLabel
            app.NmerodepxelesLabel = uilabel(app.UIFigure);
            app.NmerodepxelesLabel.FontColor = [1 1 1];
            app.NmerodepxelesLabel.Position = [369 200 110 22];
            app.NmerodepxelesLabel.Text = 'Número de píxeles:';

            % Create TamaodepxeumlLabel
            app.TamaodepxeumlLabel = uilabel(app.UIFigure);
            app.TamaodepxeumlLabel.FontColor = [1 1 1];
            app.TamaodepxeumlLabel.Position = [369 164 122 22];
            app.TamaodepxeumlLabel.Text = 'Tamaño de píxe(um)l:';

            % Create NumPSalida
            app.NumPSalida = uieditfield(app.UIFigure, 'numeric');
            app.NumPSalida.Position = [548 200 100 22];

            % Create TamPSalida
            app.TamPSalida = uieditfield(app.UIFigure, 'numeric');
            app.TamPSalida.Position = [548 164 100 22];

            % Create DimensionesButton
            app.DimensionesButton = uibutton(app.UIFigure, 'push');
            app.DimensionesButton.ButtonPushedFcn = createCallbackFcn(app, @DimensionesButtonPushed, true);
            app.DimensionesButton.Position = [412 47 100 22];
            app.DimensionesButton.Text = 'Dimensiones';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontColor = [1 1 1];
            app.Label.Position = [73 91 575 22];
            app.Label.Text = '';

            % Create DiseadordelespectrmetroCzernyTurnerLabel
            app.DiseadordelespectrmetroCzernyTurnerLabel = uilabel(app.UIFigure);
            app.DiseadordelespectrmetroCzernyTurnerLabel.FontSize = 15;
            app.DiseadordelespectrmetroCzernyTurnerLabel.FontWeight = 'bold';
            app.DiseadordelespectrmetroCzernyTurnerLabel.Position = [227 464 358 22];
            app.DiseadordelespectrmetroCzernyTurnerLabel.Text = {'Diseñador del espectrómetro Czerny-Turner'; ''};

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [625 52 100 100];
            app.Image2.ImageSource = 'CHASQUI.png';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end