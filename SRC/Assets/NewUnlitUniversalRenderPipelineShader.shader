Shader "Custom/NewUnlitUniversalRenderPipelineShader"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            ZTest Greater


            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.normal = IN.normal.xyz;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv) * _BaseColor;
                // half4 color = half4(1,0,1,1);
                // half4 color = half4(IN.normal.xyz, 1);
                // half4 color = half4(IN.normal.xyz * 0.5 + 0.5, 1);

                // グラデーション
                //half4 color = lerp(half4(1, 1, 0, 1) * 0.9, half4(0, 1, 1, 1) * 5, IN.normal.x * 0.5 + 0.5);

                // 虹グラデーション
                 float t = IN.normal.x * 0.5 + 0.5;
                half4 color = half4((t >= 1.0 / 3.0 && t < 2.0 / 3.0) ? saturate(abs(3 * (3 * t - 1) + half3(-1.5, -1, -2)) * half3(1, -1, -1) + half3(-0.5, 1, 1)) : half3(1, 1, 1), 1);                return color;
            }
            ENDHLSL
        }
    }
}
