using System;

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class SakuraShaderGui : ShaderGUI
    {
        private bool _isCutout;
        private bool _isFoldOutAdvancedExpand;
        private bool _isFoldOutMainExpand;
        private bool _isFoldOutOutlineExpand;
        private bool _isTransparent;

        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _MainTex = FindProperty(nameof(_MainTex), properties, false);
            _Color = FindProperty(nameof(_Color), properties, false);
            _UseVertexColor = FindProperty(nameof(_UseVertexColor), properties, false);
            _VertexColorBlendMode = FindProperty(nameof(_VertexColorBlendMode), properties, false);
            _Alpha = FindProperty(nameof(_Alpha), properties, false);
            _AlphaMask = FindProperty(nameof(_AlphaMask), properties, false);
            _Cutout = FindProperty(nameof(_Cutout), properties, false);
            _CutoutMask = FindProperty(nameof(_CutoutMask), properties, false);
            _BumpMap = FindProperty(nameof(_BumpMap), properties, false);
            _OcclusionMap = FindProperty(nameof(_OcclusionMap), properties, false);

            _EnableToon = FindProperty(nameof(_EnableToon), properties, false);
            _ToonStrength = FindProperty(nameof(_ToonStrength), properties, false);

            _EnableCustomLightings = FindProperty(nameof(_EnableCustomLightings), properties, false);
            _Unlighting = FindProperty(nameof(_Unlighting), properties, false);

            _EnableEmission = FindProperty(nameof(_EnableEmission), properties, false);
            _EmissionColor = FindProperty(nameof(_EmissionColor), properties, false);
            _EmissionMask = FindProperty(nameof(_EmissionMask), properties, false);

            _EnableParallaxEmission = FindProperty(nameof(_EnableParallaxEmission), properties, false);
            _ParallaxEmissionTex = FindProperty(nameof(_ParallaxEmissionTex), properties, false);
            _ParallaxEmissionMask = FindProperty(nameof(_ParallaxEmissionMask), properties, false);

            _EnableOutline = FindProperty(nameof(_EnableOutline), properties, false);
            _OutlineWidth = FindProperty(nameof(_OutlineWidth), properties, false);
            _OutlineColor = FindProperty(nameof(_OutlineColor), properties, false);
            _OutlineTex = FindProperty(nameof(_OutlineTex), properties, false);
            _OutlineMask = FindProperty(nameof(_OutlineMask), properties, false);
            _UseMainTexColorInOutline = FindProperty(nameof(_UseMainTexColorInOutline), properties, false);

            _EnableRimLighting = FindProperty(nameof(_EnableRimLighting), properties, false);
            _RimLightingColor = FindProperty(nameof(_RimLightingColor), properties, false);
            _RimLightingMask = FindProperty(nameof(_RimLightingMask), properties, false);

            _EnableReflection = FindProperty(nameof(_EnableReflection), properties, false);
            _ReflectionMask = FindProperty(nameof(_ReflectionMask), properties, false);
            _ReflectionSmoothness = FindProperty(nameof(_ReflectionSmoothness), properties, false);

            _EnableVoxelization = FindProperty(nameof(_EnableVoxelization), properties, false);

            _EnableWireframe = FindProperty(nameof(_EnableWireframe), properties, false);

            _AlphaToMask = FindProperty(nameof(_AlphaToMask), properties, false);
            _Culling = FindProperty(nameof(_Culling), properties, false);
            _ZWrite = FindProperty(nameof(_ZWrite), properties, false);

            _isCutout = material.shader.name.Contains("Cutout");
            _isTransparent = material.shader.name.Contains("Transparent");

            OnMainSection(me);
            OnShadingSection(me);
            OnEmissionSection(me);
            OnParallaxEmissionSection(me);
            OnOutlineSection(me);
            OnRimLightingSection(me);
            OnReflectionSection(me);
            OnVoxelizationSection(me);
            OnWireframeSection(me);
            OnAdvancedSection(me);
        }

        private void OnMainSection(MaterialEditor me)
        {
            using (new Section("Main"))
            {
                me.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTex, _Color);
                me.TextureScaleOffsetProperty(_MainTex);

                if (_isTransparent)
                {
                    EditorGUILayout.Space();

                    me.ShaderProperty(_Alpha, "Alpha Transparent");
                    me.TexturePropertySingleLine(new GUIContent("Alpha Mask"), _AlphaMask);
                    me.TextureScaleOffsetProperty(_AlphaMask);
                }

                if (_isCutout)
                {
                    EditorGUILayout.Space();

                    me.ShaderProperty(_Cutout, "Cutout Threshold");
                    me.TexturePropertySingleLine(new GUIContent("Cutout Mask"), _CutoutMask);
                    me.TextureScaleOffsetProperty(_CutoutMask);
                }

                EditorGUILayout.Space();

                me.TexturePropertySingleLine(new GUIContent("Normal Map"), _BumpMap);
                me.TextureScaleOffsetProperty(_BumpMap);

                EditorGUILayout.Space();

                me.TexturePropertySingleLine(new GUIContent("Occlusion Map"), _OcclusionMap);
                me.TextureScaleOffsetProperty(_OcclusionMap);

                using (new EditorGUI.IndentLevelScope())
                {
                    _isFoldOutMainExpand = EditorGUILayout.Foldout(_isFoldOutMainExpand, "Advanced Settings");

                    if (_isFoldOutMainExpand)
                    {
                        me.ShaderProperty(_UseVertexColor, "Use Vertex Color");
                        using (new EditorGUI.DisabledGroupScope(IsFalse(_UseVertexColor)))
                            me.ShaderProperty(_VertexColorBlendMode, "Vertex Color Blend Mode");
                    }
                }
            }
        }

        private void OnShadingSection(MaterialEditor me) { }

        private void OnEmissionSection(MaterialEditor me) { }

        private void OnParallaxEmissionSection(MaterialEditor me) { }

        private void OnOutlineSection(MaterialEditor me)
        {
            using (new Section("Outline"))
            {
                me.ShaderProperty(_EnableOutline, "Enable Outline");

                if (IsTrue(_EnableOutline))
                {
                    me.TexturePropertySingleLine(new GUIContent("Outline Mask"), _OutlineMask);
                    me.TextureScaleOffsetProperty(_OutlineMask);

                    me.ShaderProperty(_OutlineColor, "Outline Color");
                    me.ShaderProperty(_OutlineWidth, "Outline Width");

                    using (new EditorGUI.IndentLevelScope())
                    {
                        _isFoldOutOutlineExpand = EditorGUILayout.Foldout(_isFoldOutOutlineExpand, "Advanced Settings");

                        if (_isFoldOutOutlineExpand)
                        {
                            me.TexturePropertySingleLine(new GUIContent("Outline Texture"), _OutlineTex);
                            me.TextureScaleOffsetProperty(_OutlineTex);

                            me.ShaderProperty(_UseMainTexColorInOutline, "Use Main Texture Color");
                        }
                    }
                }
            }
        }

        private void OnRimLightingSection(MaterialEditor me) { }

        private void OnReflectionSection(MaterialEditor me)
        {
            using (new Section("Reflection"))
            {
                me.ShaderProperty(_EnableReflection, "Enable Reflection");

                if (IsTrue(_EnableReflection))
                {
                    me.TexturePropertySingleLine(new GUIContent("Reflection Mask"), _ReflectionMask);
                    me.TextureScaleOffsetProperty(_ReflectionMask);

                    me.ShaderProperty(_ReflectionSmoothness, "Reflection Smoothness");
                }
            }
        }

        private void OnVoxelizationSection(MaterialEditor me) { }

        private void OnWireframeSection(MaterialEditor me) { }

        private void OnAdvancedSection(MaterialEditor me)
        {
            using (new Section("Advanced Settings"))
            {
                if (_isCutout)
                    me.ShaderProperty(_AlphaToMask, "Alpha To Mask");
                me.ShaderProperty(_Culling, "Culling Mode");
                me.ShaderProperty(_ZWrite, "ZWrite");

                me.EnableInstancingField();
                me.RenderQueueField();
            }
        }

        private bool IsFalse(MaterialProperty property)
        {
            return property.floatValue < 0.5;
        }

        private bool IsTrue(MaterialProperty property)
        {
            return property.floatValue > 0.5;
        }

        private class Section : IDisposable
        {
            private readonly IDisposable _disposable;

            public Section(string title)
            {
                GUILayout.Label(title, EditorStyles.boldLabel);
                _disposable = new EditorGUILayout.VerticalScope(GUI.skin.box);
            }

            public void Dispose()
            {
                _disposable.Dispose();

                EditorGUILayout.Space();
            }
        }

        #region Material Properties

        private MaterialProperty _Alpha;
        private MaterialProperty _AlphaMask;
        private MaterialProperty _AlphaToMask;
        private MaterialProperty _BumpMap;
        private MaterialProperty _Color;
        private MaterialProperty _Culling;
        private MaterialProperty _Cutout;
        private MaterialProperty _CutoutMask;
        private MaterialProperty _EmissionColor;
        private MaterialProperty _EmissionMask;
        private MaterialProperty _EnableCustomLightings;
        private MaterialProperty _EnableEmission;
        private MaterialProperty _EnableOutline;
        private MaterialProperty _EnableParallaxEmission;
        private MaterialProperty _EnableReflection;
        private MaterialProperty _EnableRimLighting;
        private MaterialProperty _EnableToon;
        private MaterialProperty _EnableVoxelization;
        private MaterialProperty _EnableWireframe;
        private MaterialProperty _MainTex;
        private MaterialProperty _OcclusionMap;
        private MaterialProperty _OutlineColor;
        private MaterialProperty _OutlineTex;
        private MaterialProperty _OutlineMask;
        private MaterialProperty _OutlineWidth;
        private MaterialProperty _ParallaxEmissionMask;
        private MaterialProperty _ParallaxEmissionTex;
        private MaterialProperty _ReflectionMask;
        private MaterialProperty _ReflectionSmoothness;
        private MaterialProperty _RimLightingColor;
        private MaterialProperty _RimLightingMask;
        private MaterialProperty _ToonStrength;
        private MaterialProperty _Unlighting;
        private MaterialProperty _UseVertexColor;
        private MaterialProperty _UseMainTexColorInOutline;
        private MaterialProperty _VertexColorBlendMode;
        private MaterialProperty _ZWrite;

        #endregion
    }

    public enum BlendMode
    {
        NoBlend,

        Blend
    }
}