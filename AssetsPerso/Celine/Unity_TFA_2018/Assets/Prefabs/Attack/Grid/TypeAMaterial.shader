// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HEAJ/Celine/TypeAMaterial"
{
	Properties
	{
		_Normal("Normal", 2D) = "bump" {}
		_Emission("Emission", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_MetalSmoothness("MetalSmoothness", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0.8632262,0.6565744,1.294118,0)
		_GridLerpValue("_GridLerpValue", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _MetalSmoothness;
		uniform float4 _MetalSmoothness_ST;
		uniform float _GridLerpValue;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( tex2D( _Emission, uv_Emission ) * _EmissionColor ).rgb;
			float2 uv_MetalSmoothness = i.uv_texcoord * _MetalSmoothness_ST.xy + _MetalSmoothness_ST.zw;
			float4 tex2DNode5 = tex2D( _MetalSmoothness, uv_MetalSmoothness );
			o.Metallic = tex2DNode5.r;
			o.Smoothness = tex2DNode5.a;
			float lerpResult40 = lerp( 1 , 0 , _GridLerpValue);
			o.Alpha = lerpResult40;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
610;364;1370;1001;427.484;126.2395;1.698585;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;10;-633.4374,-504.484;Float;True;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;f5ac0797166a7a64b908fda9f4705e05;f5ac0797166a7a64b908fda9f4705e05;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-640.9406,-726.9799;Float;True;Property;_Normal;Normal;0;0;Create;True;0;0;False;0;93f9ca20129726a46994a9e111f7cfad;93f9ca20129726a46994a9e111f7cfad;True;bump;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-818.8927,-951.7543;Float;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;False;0;e1443607a0e54bc41b50f9840d9610da;e1443607a0e54bc41b50f9840d9610da;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;41;430.4641,68.16188;Float;False;Constant;_Color1;Color 1;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;6;-563.1804,232.5922;Float;True;Property;_MetalSmoothness;MetalSmoothness;4;0;Create;True;0;0;False;0;7ee77d23a4b61854d9aff828341fdc8f;7ee77d23a4b61854d9aff828341fdc8f;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;38;434.3607,-91.80833;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-292.7461,-502.151;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-224.5813,-283.6631;Float;False;Property;_EmissionColor;Emission Color;5;1;[HDR];Create;True;0;0;False;0;0.8632262,0.6565744,1.294118,0;0.8666668,0.6576471,1.3,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;308.0378,321.8195;Float;False;Property;_GridLerpValue;_GridLerpValue;6;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;126.892,-302.3376;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-146.7151,235.2339;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;40;683.0052,96.47449;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-370.3215,-952.4523;Float;True;Property;_TextureSample4;Texture Sample 4;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-286.1761,-723.7159;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1166.259,-21.23761;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;HEAJ/Celine/TypeAMaterial;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;10;0
WireConnection;32;0;9;0
WireConnection;32;1;33;0
WireConnection;5;0;6;0
WireConnection;40;0;38;1
WireConnection;40;1;41;2
WireConnection;40;2;39;0
WireConnection;12;0;11;0
WireConnection;7;0;8;0
WireConnection;0;0;12;0
WireConnection;0;1;7;0
WireConnection;0;2;32;0
WireConnection;0;3;5;0
WireConnection;0;4;5;4
WireConnection;0;9;40;0
ASEEND*/
//CHKSM=B3DA45735B90522F012AFC999BD8BF2A89CEBD82