/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

#if defined(RENDER_PASS_FB) || defined(RENDER_PASS_FA)

fixed4 fs(const g2f v) : SV_TARGET
{
    fixed4 color = _MainTex.Sample(sampler_MainTex, v.uv);

    return color;
}

#elif defined(RENDER_PASS_SC)

fixed4 fs(const g2f v) : SV_TARGET
{
    SHADOW_CASTER_FRAGMENT(v)
}

#endif