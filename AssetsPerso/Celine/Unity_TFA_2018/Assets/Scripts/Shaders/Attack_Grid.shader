Shader "HEAJ/Celine/Attack_Grid" 
{
    Properties
	{
        [NoScaleOffset]_LineTexture ("Line Texture", 2D) = "black" {}
        [NoScaleOffset]_MainTex ("MainTex", 2D) = "black" {}
		[HDR]_LineColor ("Line Color", Color) = (1,1,1,1)	
		_GridLerpValue("Grid Lerp Value", Range(0,1)) = 0.5
    }
    SubShader 
	{     
	   Tags {"Queue" = "Transparent"}	
       Pass
	   {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite On
			Cull Off
			CGPROGRAM
			#pragma vertex vert								
			#pragma fragment frag							
			#pragma target 5.0

			sampler2D _MainTex;
			sampler2D _LineTexture;
			float3 _LineColor;
			float _GridLerpValue;

 
			struct appdata
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
				{
					float4 pos : SV_POSITION;
					float3 N : ATTR0;
					float3 wPos : ATTR1;						
					float2 UV : ATTR2;
				};

			v2f vert(appdata v)
			{
				v2f o;
				o.UV = v.texcoord;
				o.pos = UnityObjectToClipPos(v.pos);
				o.N = mul((float3x3)unity_ObjectToWorld, v.normal);
				o.wPos = mul(unity_ObjectToWorld, v.pos).xyz;

				return o;
			}
 
			float4 frag(v2f i)  : COLOR
				{
					float4 o;

					

					float alphaGrid = tex2D(_LineTexture, i.UV).a;
					//float emissive = tex2D(_EmissiveTex, i.UV).g;
					float4 mainTex = tex2D(_MainTex, i.UV).rgba;


					o.rgb = lerp(mainTex.rgb, alphaGrid * _LineColor, _GridLerpValue);
					o.a = lerp(mainTex.a, alphaGrid, _GridLerpValue);

					return o;
				};
			ENDCG
		}
	}
}