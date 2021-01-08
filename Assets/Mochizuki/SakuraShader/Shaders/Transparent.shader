/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Transparent"
{
    Properties
    {
        // Main Shading
        _MainTex                ("Main Texture",                           2D) = "white" {}
        _Color                  ("Main Color",                          Color) = (1, 1, 1, 1)
        _Alpha                  ("Alpha",                               Float) = 1.0
        [Toggle]
        _VertexColor            ("Use Vertex Color",                      Int) = 0
        [Normal]
        _BumpMap                ("Normal Map",                             2D) = "white" {}

        // Toon Shading
        [Toggle]
        _EnableToon             ("Enable Toon Shading",                   Int) = 0
        _ToonStrength           ("Toon Strength",             Range(0.0, 1.0)) = 0.0

        // Lightings
        [Toggle]
        _EnableCustomLightings  ("Enable Custom Lightings",               Int) = 0

        // Emission
        [Toggle]
        _EnableEmission         ("Enable Emission",                       Int) = 0

        // Parallax Emission
        [Toggle]
        _EnableParallaxEmission ("Enable Parallax Emission",              Int) = 0

        // Rim Lighting
        [Toggle]
        _EnableRimLighting      ("Enable Rim Lighting",                   Int) = 0

        // Reflection
        [Toggle]
        _EnableReflection       ("Enable Reflection",                     Int) = 0

        // Outline
        [Toggle]
        _EnableOutline          ("Enable Outline",                        Int) = 0
        _OutlineWidth           ("Outline Width",            Range(0.0, 20.0)) = 0.0
        _OutlineColor           ("Outline Color",                       Color) = (0, 0, 0, 1)
        _OutlineMask            ("Outline Mask",                           2D) = "white" {}

        // Voxelization
        [Toggle]
        _EnableVoxelization     ("Enable Voxelization",                   Int) = 0

        // Wireframe
        [Toggle]
        _EnableWireframe        ("Enable Wireframe",                      Int) = 0

        // Advanced
        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling                ("Culling",                               Int) = 0
        [Enum(Off,0,On,1)]
        _ZWrite                 ("ZWrite",                                Int) = 0
    }

    SubShader
    {
        LOD 0

        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "IgnoreProjector" = "True"
        }

        CGINCLUDE

        #pragma target  4.5
        #pragma require geometry
        // #pragma require tessellation

        #pragma vertex   vs
        // #pragma hull     hs
        // #pragma domain   ds
        #pragma geometry gs
        #pragma fragment fs

        #define SHADER_VARIANT_TRANSPARENT

        ENDCG

        Pass
        {
            Name "Forward"

            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            Cull   [_Culling]
            ZWrite [_ZWrite]

            CGPROGRAM

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #define RENDER_PASS_FB

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name "ForwardDelta"

            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend  SrcAlpha One
            Cull   Back
            ZWrite Off

            CGPROGRAM

            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog

            #define RENDER_PASS_FA

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name "ShadowCaster"

            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            ZWrite On
            ZTest  LEqual

            CGPROGRAM

            #pragma multi_compile_shadowcaster

            #define RENDER_PASS_SC

            #include "includes/core.cginc"

            ENDCG
        }
    }

    Fallback "Diffuse"

    // CustomEditor "Mochizuki.SakuraShader.SakuraShaderGui"
}