using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class VibrationTest : MonoBehaviour 
{
	public KeyCode VibrationKey;
	public KeyCode StopVib;

	void Start () 
	{
		
	}
	
	void Update () 
	{
		if(Input.GetKey(VibrationKey))
		{
			GamePad.SetVibration(PlayerIndex.One,10f,10f);
		}
		if(Input.GetKey(StopVib))
		{
			GamePad.SetVibration(PlayerIndex.One,0.0f,0.0f);
		}
	}
}
