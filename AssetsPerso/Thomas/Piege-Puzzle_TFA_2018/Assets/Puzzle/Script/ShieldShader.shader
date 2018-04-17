// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ForceFlied"
{
	Properties
	{
		[Header(Refraction)]
		_ChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0.1
		_DistortMask("DistortMask", 2D) = "white" {}
		_DistortScale("DistortScale", Vector) = (2,2,0,0)
		_DistortSpeed("DistortSpeed", Range( 0 , 3)) = 0
		_PannerMaskSpeed("PannerMaskSpeed", Range( 0 , 5)) = 0.02
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Opacity("Opacity", Range( 0 , 1.5)) = 1.5
		_DissolveMask("DissolveMask", 2D) = "white" {}
		_DissolveAmount("DissolveAmount", Range( 0 , 1)) = 0
		_DetailsColor("DetailsColor", Color) = (0.2264197,0,0.6985294,0)
		_SphereColor("SphereColor", Color) = (0.1043103,0,0.8897059,0)
		_FresnelScale("FresnelScale", Range( 0 , 2)) = 0.4235294
		_FrenselPower("FrenselPower", Range( 0 , 5)) = 0.4235294
		_EmissiveIntensity("EmissiveIntensity", Range( 0 , 10)) = 10
		_ColorFresnel("ColorFresnel", Color) = (0,0,0,0)
		_Clouds("Clouds", 2D) = "white" {}
		_HexagonalPattern("HexagonalPattern", 2D) = "white" {}
		_MaskPattern("MaskPattern", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform float4 _SphereColor;
		uniform float4 _DetailsColor;
		uniform sampler2D _HexagonalPattern;
		uniform float4 _HexagonalPattern_ST;
		uniform sampler2D _MaskPattern;
		uniform float _PannerMaskSpeed;
		uniform float _EmissiveIntensity;
		uniform float4 _ColorFresnel;
		uniform float _FresnelScale;
		uniform float _FrenselPower;
		uniform sampler2D _Clouds;
		uniform float4 _Clouds_ST;
		uniform float _Opacity;
		uniform float _DissolveAmount;
		uniform sampler2D _DissolveMask;
		uniform float4 _DissolveMask_ST;
		uniform sampler2D _GrabTexture;
		uniform float _ChromaticAberration;
		uniform sampler2D _DistortMask;
		uniform float2 _DistortScale;
		uniform float _DistortSpeed;
		uniform float _Cutoff = 0.5;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline float4 Refraction( Input i, SurfaceOutputStandard o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( ( ( ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) ) * ( 1.0 / ( screenPos.z + 1.0 ) ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) ) );
			float2 cameraRefraction = float2( refractionOffset.x, -( refractionOffset.y * _ProjectionParams.x ) );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandard o, inout fixed4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float mulTime81 = _Time.y * 1;
			float2 temp_cast_3 = (_DistortSpeed).xx;
			float2 uv_TexCoord82 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner80 = ( uv_TexCoord82 + mulTime81 * temp_cast_3);
			float2 uv_TexCoord79 = i.uv_texcoord * _DistortScale + panner80;
			float4 Refraction107 = ( ase_grabScreenPosNorm + tex2D( _DistortMask, uv_TexCoord79 ) );
			color.rgb = color.rgb + Refraction( i, o, Refraction107.x, _ChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_HexagonalPattern = i.uv_texcoord * _HexagonalPattern_ST.xy + _HexagonalPattern_ST.zw;
			float mulTime126 = _Time.y * 1;
			float2 temp_cast_0 = (_PannerMaskSpeed).xx;
			float2 uv_TexCoord128 = i.uv_texcoord * float2( 5,5 ) + float2( 0,0 );
			float2 panner127 = ( uv_TexCoord128 + mulTime126 * temp_cast_0);
			float4 temp_output_16_0 = ( _DetailsColor * ( tex2D( _HexagonalPattern, uv_HexagonalPattern ) * tex2D( _MaskPattern, panner127 ) ) );
			float4 temp_output_89_0 = ( ( _SphereColor * ( 1.0 - temp_output_16_0 ) ) + temp_output_16_0 );
			float4 Albedo110 = temp_output_89_0;
			o.Albedo = Albedo110.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNDotV95 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode95 = ( 0 + _FresnelScale * pow( 1.0 - fresnelNDotV95, _FrenselPower ) );
			float2 uv_Clouds = i.uv_texcoord * _Clouds_ST.xy + _Clouds_ST.zw;
			float4 Emissive109 = ( temp_output_89_0 + ( _EmissiveIntensity * ( _ColorFresnel * fresnelNode95 * tex2D( _Clouds, uv_Clouds ) ) ) );
			o.Emission = Emissive109.rgb;
			o.Alpha = _Opacity;
			float2 uv_DissolveMask = i.uv_texcoord * _DissolveMask_ST.xy + _DissolveMask_ST.zw;
			float OpacityMask105 = ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0) * (0.6 - -0.6) / (1 - 0)) + tex2D( _DissolveMask, uv_DissolveMask ).r );
			clip( OpacityMask105 - _Cutoff );
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha finalcolor:RefractionF fullforwardshadows exclude_path:deferred 

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
				float4 screenPos : TEXCOORD2;
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
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
Version=14501
-1913;29;1906;1044;1466.433;666.7749;1.084283;True;False
Node;AmplifyShaderEditor.RangedFloatNode;129;-3017.223,-567.6824;Float;False;Property;_PannerMaskSpeed;PannerMaskSpeed;7;0;Create;True;0;0.02;0.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;126;-2947.045,-406.545;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-3021.045,-290.5453;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;127;-2722.217,-399.6824;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;125;-2446.29,-240.7618;Float;True;Property;_MaskPattern;MaskPattern;22;0;Create;True;0;None;4a63b97acd3d1e5488f8b00ff954aac8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;-2420.113,-641.282;Float;True;Property;_HexagonalPattern;HexagonalPattern;21;0;Create;True;0;None;bc6fe8a5f67f21b43a831a32770d790c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1945.165,-339.3547;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;-2093.673,-906.6305;Float;False;Property;_DetailsColor;DetailsColor;14;0;Create;True;0;0.2264197,0,0.6985294,0;0.5,0.5,0.5,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-2652.152,928.1649;Float;False;Property;_DistortSpeed;DistortSpeed;3;0;Create;True;0;0;0.02;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1751.639,-600.687;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-1679.593,-362.7496;Float;False;Property;_FresnelScale;FresnelScale;16;0;Create;True;0;0.4235294;1.314706;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1690.593,-238.7496;Float;False;Property;_FrenselPower;FrenselPower;17;0;Create;True;0;0.4235294;2.14;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-2606.277,737.9316;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;81;-2556.636,1072.545;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-1418.961,-46.96323;Float;True;Property;_Clouds;Clouds;20;0;Create;True;0;None;2807a94313aa7984687ea84089c4ac69;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;102;-1278.74,-549.9716;Float;False;Property;_ColorFresnel;ColorFresnel;19;0;Create;True;0;0,0,0,0;0,0.02175462,0.2426471,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;78;-2167.999,634.3035;Float;False;Property;_DistortScale;DistortScale;2;0;Create;True;0;2,2;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;80;-2311.364,864.6278;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;84;-1528.932,-940.6151;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;86;-1556.932,-1200.615;Float;False;Property;_SphereColor;SphereColor;15;0;Create;True;0;0.1043103,0,0.8897059,0;0,0.1410243,0.1985294,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;95;-1388.593,-370.7496;Float;True;Tangent;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-335.4765,698.1285;Float;False;Property;_DissolveAmount;DissolveAmount;12;0;Create;True;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1293.764,-1038.282;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-910.5928,-509.7497;Float;False;Property;_EmissiveIntensity;EmissiveIntensity;18;0;Create;True;0;10;5.710588;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-885.5927,-410.7497;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-1914.228,800.6728;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;91;-32.68108,698.9745;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;67;-1756.687,539.3484;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-875.7045,-874.0995;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;73;-1622.711,783.5605;Float;True;Property;_DistortMask;DistortMask;1;0;Create;True;0;8f811cba2413e0f4abc6d6ef517132ac;ad2ee3c2b3cf4de4393d58004fb0baa5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;92;104.0072,914.7809;Float;True;Property;_DissolveMask;DissolveMask;11;0;Create;True;0;None;ad2ee3c2b3cf4de4393d58004fb0baa5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-622.593,-424.7497;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;94;152.1355,707.759;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;341.8819,682.261;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-268.7395,-455.9716;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1348.052,598.8026;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;747.874,371.4654;Float;False;105;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-4959.557,-666.3749;Float;True;Property;_TexPositveUV;TexPositveUV;5;0;Create;True;0;e28dc97a9541e3642a48c0e3886688c5;a6e55683a3c731944932172f48da43c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-5546.583,-670.9758;Float;False;Property;_PositiveUV;PositiveUV;6;0;Create;True;0;0.02;0.02;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;774.8325,153.793;Float;False;107;0;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;114;-4005.033,-481.3461;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;674.1584,265.4149;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;1.5;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-5507.406,-382.8388;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;115;-4244.866,-480.7256;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;-10,0,0,0;False;4;COLOR;10,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-5433.406,-498.8384;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;55;-5169.703,-219.4627;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;44;-5186.577,-709.9758;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-3472.364,-400.6722;Float;True;Property;_GrandientTex;GrandientTex;13;0;Create;True;0;a79aae10ed581314393883b75b8ed172;a79aae10ed581314393883b75b8ed172;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;112;785.3414,-104.8035;Float;False;110;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;804.3414,9.196533;Float;False;109;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-4586.021,-378.2411;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-91.0791,-863.4653;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-5482.709,-160.4628;Float;False;Property;_NegativeUV;NegativeUV;8;0;Create;True;0;-0.02;-0.02;-5;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;91.3213,-442.8653;Float;False;Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;12;-3682.683,-519.0629;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1121.167,592.793;Float;True;Refraction;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;526.3167,693.8567;Float;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-4946.094,-276.1201;Float;True;Property;_TexNegativeUV;TexNegativeUV;4;0;Create;True;0;e28dc97a9541e3642a48c0e3886688c5;a6e55683a3c731944932172f48da43c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1072.529,-33.49446;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/ForceFlied;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Back;2;0;False;0;0;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;9;-1;0;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;127;0;128;0
WireConnection;127;2;129;0
WireConnection;127;1;126;0
WireConnection;125;1;127;0
WireConnection;122;0;119;0
WireConnection;122;1;125;0
WireConnection;16;0;15;0
WireConnection;16;1;122;0
WireConnection;80;0;82;0
WireConnection;80;2;83;0
WireConnection;80;1;81;0
WireConnection;84;0;16;0
WireConnection;95;2;98;0
WireConnection;95;3;96;0
WireConnection;85;0;86;0
WireConnection;85;1;84;0
WireConnection;97;0;102;0
WireConnection;97;1;95;0
WireConnection;97;2;116;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;91;0;90;0
WireConnection;89;0;85;0
WireConnection;89;1;16;0
WireConnection;73;1;79;0
WireConnection;99;0;100;0
WireConnection;99;1;97;0
WireConnection;94;0;91;0
WireConnection;93;0;94;0
WireConnection;93;1;92;1
WireConnection;103;0;89;0
WireConnection;103;1;99;0
WireConnection;69;0;67;0
WireConnection;69;1;73;0
WireConnection;1;1;44;0
WireConnection;114;0;115;0
WireConnection;115;0;56;0
WireConnection;55;0;53;0
WireConnection;55;2;54;0
WireConnection;55;1;52;0
WireConnection;44;0;53;0
WireConnection;44;2;45;0
WireConnection;44;1;52;0
WireConnection;3;1;12;0
WireConnection;56;0;1;0
WireConnection;56;1;51;0
WireConnection;110;0;89;0
WireConnection;109;0;103;0
WireConnection;12;0;114;0
WireConnection;107;0;69;0
WireConnection;105;0;93;0
WireConnection;51;1;55;0
WireConnection;0;0;112;0
WireConnection;0;2;111;0
WireConnection;0;8;108;0
WireConnection;0;9;17;0
WireConnection;0;10;106;0
ASEEND*/
//CHKSM=5104368A9607F43870938C0D8CDB4CC66B36D8F5