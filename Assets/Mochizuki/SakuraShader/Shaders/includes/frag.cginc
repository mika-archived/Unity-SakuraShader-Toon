/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)

half4 fs(const g2f v) : SV_TARGET
{
    const fixed4   baseColor        = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(v.uv, _MainTex)) * _Color;
    const fixed3   lightColor       = _LightColor0.rgb;
    const fixed3   tangent          = normalize(v.tangent);
    const fixed3   binormal         = normalize(v.binormal);
    const float3   lightDir         = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - v.worldPos, _WorldSpaceLightPos0.w));
    const fixed3x3 tangentTransform = transpose(float3x3(tangent, binormal, normalize(v.normal)));
    const fixed3   normal           = normalize(mul(tangentTransform, UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_BumpMap, _MainTex, TRANSFORM_TEX(v.uv, _BumpMap)))));

    const float  diffuse = pow(saturate(dot(normal, lightDir)) * 0.5 + 0.5, 2);

    half4 finalColor = baseColor * diffuse * fixed4(lightColor, 1.0);
    UNITY_APPLY_FOG(v.fogCoord, finalColor);

    return finalColor; 
}

#elif defined(RENDER_PASS_OL_FB)

half4 fs(const g2f v) : SV_TARGET
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