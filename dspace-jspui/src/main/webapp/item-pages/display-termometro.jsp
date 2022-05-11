<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%@page contentType="text/html;charset=UTF-8" %>



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



