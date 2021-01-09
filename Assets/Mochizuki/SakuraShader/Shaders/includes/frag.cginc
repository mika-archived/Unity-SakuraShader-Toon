/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)

fixed4 fs(const g2f v) : SV_TARGET
{
    const fixed4 color = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex));
    return color;
}

#elif defined(RENDER_PASS_OL_FB)

fixed4 fs(const g2f v) : SV_TARGET
{
    fixed4 baseColor = tex2D(_OutlineTex, TRANSFORM_TEX(v.uv, _OutlineTex)) * _OutlineColor;

    if (_UseMainTexColorInOutline)
    {
        baseColor.rgb *= UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex));
    }

    const float outlineMask = toMonochrome(UNITY_SAMPLE_TEX2D_SAMPLER(_OutlineMask, _MainTex, TRANSFORM_TEX(v.uv, _OutlineMask)));
    clip(outlineMask - 0.2);
    
    return baseColor;
}

#elif defined(RENDER_PASS_SC)

fixed4 fs(const g2f v) : SV_TARGET
{
    SHADOW_CASTER_FRAGMENT(v)
}

#endif