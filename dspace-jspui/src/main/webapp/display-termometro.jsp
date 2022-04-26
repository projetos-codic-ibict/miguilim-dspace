<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%@page contentType="text/html;charset=UTF-8" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    String pontuacaoTermometro = (String) request.getAttribute("pontuacao");
%>


<style id="style-termometro">

    .header-termometro {
        text-align: center;
        margin-top: 50px;
    }

    .header-termometro p {
        color: #9e1822;
    }

    #div-termometro {
        background: rgba(200, 200, 200, 0.99);
        position: relative;
        color: #fff;
        width: 380px;
        height: 300px;
        margin-bottom: 50px;
        -webkit-border-radius: 10px;
        -moz-border-radius: 10px;
        border-radius: 10px;
        clear: both;
        padding: 0 15px;
    }

    #canvas-termometro {
        width: 380px;
        top: 40px;
        right: 16px;
        position: relative;
    }

    #preview-textfield {
        position: relative;
        padding-top: 20px;
        top: 1px;
        left: 0;
        right: 0;
        text-align: center;
        font-size: 2em;
        font-weight: bold;
        color: black;
        font-family: 'Amaranth', sans-serif;
    }

</style>

<dspace:layout titlekey="termometro.display.header">

    <div class="header-termometro">
        <p>
            <fmt:message key="termometro.display.title"/>
        </p>
    </div>
    <div class="container" id="div-termometro">
        <canvas height=180 id="canvas-termometro" width=340></canvas>
        <p>
            <div id="preview-textfield"></div>
        </p>
    </div>

    <script type="text/javascript" src="<%= request.getContextPath() %>/gauge.js"> </script>
    <script type="text/javascript">
        initGauge();
        function initGauge() {
            termometro = new Gauge(document.getElementById("canvas-termometro"));
            var opts = {
                angle: 0,
                lineWidth: 0.2,
                radiusScale: 1,
                pointer: {
                    length: 0.4,
                    strokeWidth: 0.1,
                    color: '#000000'
                },
                staticLabels: {
                    font: "14px sans-serif",
                    labels: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
                    fractionDigits: 0
                },
                staticZones: [
                    {strokeStyle: "#FFDD00", min: 0, max: 80},
                    {strokeStyle: "#30B32D", min: 80, max: 100}
                ],
                pointer: {
                    length: 0.45,
                    strokeWidth: 0.029,
                    color: '#000000'
                },
                renderTicks: {
                    divisions: 100,
                    divWidth: 0.5,
                    divLength: 0.1,
                    divColor: '#333333',
                    subDivisions: 1,
                    subLength: 0.5,
                    subWidth: 0.6,
                    subColor: '#666666'
                },
                limitMax: true,
                limitMin: false,
                highDpiSupport: true
            };
            termometro.setOptions(opts);
            termometro.minValue = 0;
            termometro.maxValue = 100;
            termometro.animationSpeed = 50;
            termometro.set(<%= pontuacaoTermometro %>);
            termometro.setTextField(document.getElementById("preview-textfield"));
        }
    </script>

</dspace:layout>

