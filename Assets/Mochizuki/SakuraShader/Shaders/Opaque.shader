/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Opaque"
{
    Properties
    {
        // Main Shading
        _MainTex                  ("Main Texture",                           2D) = "white" {}
        _Color                    ("Main Color",                          Color) = (1, 1, 1, 1)
        [Toggle]
        _UseVertexColor           ("Use Vertex Color",                      Int) = 0
        [Enum(Mochizuki.SakuraShader.BlendMode)]
        _VertexColorBlendMode     ("Vertex Color Blend Mode",               Int) = 1
        [Normal]
        _BumpMap                  ("Normal Map",                             2D) = "bump" {}
        _BumpScale                ("Normal Scale",             Range(-2.0, 2.0)) = 1.0
        _ParallaxMap              ("Height Map",                             2D) = "bump" {}
        _ParallaxScale            ("Height Scale",             Range(-2.0, 2.0)) = 1.0
        _OcclusionMap             ("Occlusion Map",                          2D) = "white" {}

        // Toon Shading
        [Toggle]
        _EnableToon               ("Enable Toon Shading",                   Int) = 0
        _ToonStrength             ("Toon Strength",             Range(0.0, 1.0)) = 0.0

        // Lightings
        [Toggle]
        _EnableCustomLightings    ("Enable Custom Lightings",               Int) = 0
        _Unlighting               ("Unlighting",                Range(0.0, 1.0)) = 0.0

        // Emission
        [Toggle]
        _EnableEmission           ("Enable Emission",                       Int) = 0
        _EmissionMask             ("Emission Mask",                          2D) = "white" {}
        [HDR]
        _EmissionColor            ("Emission Color",                      Color) = (0, 0, 0, 1)


        // Parallax Emission
        [Toggle]
        _EnableParallaxEmission   ("Enable Parallax Emission",              Int) = 0
        _ParallaxEmissionTex      ("Parallax Emission Texture",              2D) = "black" {}
        _ParallaxEmissionMask     ("Parallax Emission Mask",                 2D) = "white" {}

        // Rim Lighting
        [Toggle]
        _EnableRimLighting        ("Enable Rim Lighting",                   Int) = 0
        _RimLightingMask          ("Rim Lighting Mask",                      2D) = "white" {}
        [HDR]
        _RimLightingColor         ("Rim Lighting Color",                  Color) = (1, 1, 1, 1)

        // Reflection
        [Toggle]
        _EnableReflection         ("Enable Reflection",                     Int) = 0
        _ReflectionMask           ("Reflection Mask",                        2D) = "white" {}
        _ReflectionSmoothness     ("Reflection Smoothness",     Range(0.0, 1.0)) = 1.0

        // Outline
        [Toggle]
        _EnableOutline            ("Enable Outline",                        Int) = 0
        _OutlineMask              ("Outline Mask",                           2D) = "white" {}
        _OutlineColor             ("Outline Color",                       Color) = (0, 0, 0, 1)
        _OutlineWidth             ("Outline Width",             Range(0.0, 1.0)) = 0.0
        _OutlineTex               ("Outline Texture",                        2D) = "white" {}
        [Toggle]
        _UseMainTexColorInOutline ("Use Main Texture Color",                Int) = 0

        // Voxelization
        [Toggle]
        _EnableVoxelization       ("Enable Voxelization",                   Int) = 0

        // Wireframe
        [Toggle]
        _EnableWireframe          ("Enable Wireframe",                      Int) = 0

        // Advanced
        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling                  ("Culling",                               Int) = 2
        [Enum(Off,0,On,1)]
        _ZWrite                   ("ZWrite",                                Int) = 1
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

        #pragma target   4.5
        #pragma require  geometry
        // #pragma require tessellation

        #pragma vertex   vs
        // #pragma hull     hs
        // #pragma domain   ds
        #pragma geometry gs
        #pragma fragment fs


        #define SHADER_VARIANT_OPAQUE

        ENDCG

        Pass
        {
            Name "Forward"

            Tags
            {
                "LightMode" = "ForwardBase"
            }

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
            Name "ForwardOutline"

            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Cull   Front
            ZWrite [_ZWrite]

            CGPROGRAM

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #define RENDER_PASS_OL_FB

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

            Blend  One One
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

    Fallback "Standard"

    CustomEditor "Mochizuki.SakuraShader.SakuraShaderGui"
}