Shader "HEAJ/Celine/SkyMirror" {
	Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_LineTexture ("Line Texture", 2D) = "white" {}
		[NoScaleOffset]_EmissiveTex ("Emissive Texture", 2D) = "white" {}
		[HDR]_LineColor ("Line Color", Color) = (1,1,1,1)
		[HDR]_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_GridLerpValue("Grid Lerp Value", Range(0,1)) = 0.5
		_Metalness("Metalness", Range(0,1)) = 0.5
		_Gloss("Glossiness", Range(0,1)) = 0.5 
    }
    SubShader
    {
        Pass
        {
			Cull Off
			Lighting On
            Tags {"LightMode"="ForwardBase"}
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag							
			#pragma target 5.0
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

			sampler2D _NormalMap;
            sampler2D _MainTex;
			sampler2D _LineTexture;
			sampler2D _EmissiveTex;
			float4 _EmissiveColor;
			float3 _LineColor;
			float _GridLerpValue;
			float _Metalness;
			float _Gloss;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0;
                float4 vertex : SV_POSITION;
				half3 worldNormal : TEXCOORD5;
				float3 worldPos : TEXCOORD4;
                
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
            };

            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(vertex);
                o.uv = uv;
                half3 worldNormal = UnityObjectToWorldNormal(normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
				
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
				
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
				
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);

                
                o.diff.rgb += ShadeSH9(half4(worldNormal,1));
                return o;
            }
            
			
			

            fixed4 frag (v2f i) : SV_Target
            {
				float alphaGrid = tex2D(_LineTexture, i.uv).a;
				float emissive = tex2D(_EmissiveTex, i.uv).g;
				float4 mainTex = tex2D(_MainTex, i.uv).rgba;

				half3 normal = UnpackNormal(tex2D(_NormalMap, i.uv));
				half3 worldNormal;
                worldNormal.x = dot(i.tspace0, normal);
                worldNormal.y = dot(i.tspace1, normal);
                worldNormal.z = dot(i.tspace2, normal);
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
				fixed4 c = 0;
                c.rgb = skyColor;
				
				c.rgb *= mainTex;

				c *= i.diff;
                return c;




                //fixed4 col = tex2D(_MainTex, i.uv);
                //col *= i.diff;
                //return col;
            }
            ENDCG
        }
    }
}
