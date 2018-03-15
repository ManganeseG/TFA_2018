using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoxFixedTouch : MonoBehaviour 
{
	void OnTriggerEnter(Collider col)
	{
		Debug.Log("Touched");
		TrapTrigger.BoxFixedHaveTouched = true;
	}
}
