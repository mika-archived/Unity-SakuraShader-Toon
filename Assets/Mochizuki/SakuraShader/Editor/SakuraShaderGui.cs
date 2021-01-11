using System;

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class SakuraShaderGui : ShaderGUI
    {
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
            _BumpScale = FindProperty(nameof(_BumpScale), properties, false);
            _ParallaxMap = FindProperty(nameof(_ParallaxMap), properties, false);
            _ParallaxScale = FindProperty(nameof(_ParallaxScale), properties, false);
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
                TextureFoldout("Main Texture", me, _MainTex, ref _isFoldOutMainTextureExpand);

                if (_isTransparent)
                {
                    EditorGUILayout.Space();

                    TextureFoldout("Alpha Mask", me, _AlphaMask, ref _isFoldoutAlphaMaskExpand);
                    me.ShaderProperty(_Alpha, "Alpha Transparent");
                }

                if (_isCutout)
                {
                    EditorGUILayout.Space();

                    TextureFoldout("Cutout Mask", me, _CutoutMask, ref _isFoldoutCutoutMaskExpand);
                    me.ShaderProperty(_Cutout, "Cutout Threshold");
                }

                EditorGUILayout.Space();

                TextureFoldout("Normal Map", me, _BumpMap, ref _isFoldoutBumpMapExpand);
                me.ShaderProperty(_BumpScale, "Normal Scale");

                EditorGUILayout.Space();

                TextureFoldout("Height Map", me, _ParallaxMap, ref _isFoldoutParallaxMapExpand);
                me.ShaderProperty(_ParallaxScale, "Height Scale");

                EditorGUILayout.Space();

                TextureFoldout("Occlusion Map", me, _OcclusionMap, ref _isFoldoutOcclusionMapExpand);

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
                    TextureFoldout("Outline Mask", me, _OutlineMask, ref _isFoldoutOutlineMaskExpand);

                    me.ShaderProperty(_OutlineColor, "Outline Color");
                    me.ShaderProperty(_OutlineWidth, "Outline Width");

                    using (new EditorGUI.IndentLevelScope())
                    {
                        _isFoldOutOutlineExpand = EditorGUILayout.Foldout(_isFoldOutOutlineExpand, "Advanced Settings");

                        if (_isFoldOutOutlineExpand)
                        {
                            TextureFoldout("Outline Texture", me, _OutlineTex, ref _isFoldoutOutlineTexExpand);

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
                    TextureFoldout("Reflection Mask", me, _ReflectionMask, ref _isFoldoutReflectionMaskExpand);

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

                // me.EnableInstancingField();
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

        private void TextureFoldout(string label, MaterialEditor me, MaterialProperty property, ref bool display)
        {
            var rect = GUILayoutUtility.GetRect(16.0f, 22.0f, GUIStyle.none);
            var e = Event.current;

            me.TexturePropertyMiniThumbnail(new Rect(rect.x + 18.0f, rect.y + 2.0f, rect.width - 20.0f, rect.height), property, label, "");

            var toggle = new Rect(rect.x + 2.0f + EditorGUI.indentLevel * 16.0f, rect.y + 3.0f, 16.0f, 16.0f);
            if (e.type == EventType.Repaint)
                EditorStyles.foldout.Draw(toggle, false, false, display, false);

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                display = !display;
                e.Use();
            }

            if (display)
                using (new EditorGUI.IndentLevelScope())
                    me.TextureScaleOffsetProperty(property);
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

        // ReSharper disable InconsistentNaming

        private bool _isCutout;
        private bool _isFoldOutAdvancedExpand;
        private bool _isFoldoutAlphaMaskExpand;
        private bool _isFoldoutBumpMapExpand;
        private bool _isFoldoutCutoutMaskExpand;
        private bool _isFoldoutEmissionMaskExpand;
        private bool _isFoldOutMainExpand;
        private bool _isFoldOutMainTextureExpand;
        private bool _isFoldoutOcclusionMapExpand;
        private bool _isFoldOutOutlineExpand;
        private bool _isFoldoutOutlineMaskExpand;
        private bool _isFoldoutOutlineTexExpand;
        private bool _isFoldoutParallaxEmissionMaskExpand;
        private bool _isFoldoutParallaxEmissionTextureExpand;
        private bool _isFoldoutParallaxMapExpand;
        private bool _isFoldoutReflectionMaskExpand;
        private bool _isFoldoutRimLightingMaskExpand;
        private bool _isTransparent;

        // ReSharper restore InconsistentNaming

        #region Material Properties

        private MaterialProperty _Alpha;
        private MaterialProperty _AlphaMask;
        private MaterialProperty _AlphaToMask;
        private MaterialProperty _BumpMap;
        private MaterialProperty _BumpScale;
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
        private MaterialProperty _ParallaxMap;
        private MaterialProperty _ParallaxScale;
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