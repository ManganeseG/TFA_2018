	using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleElement : MonoBehaviour 
{
	public GameObject refTPuzzleSystem;

	void OnTriggerEnter(Collider col)
	{
		if(col.tag == "FirstPart")
		{
			PuzzleTanvir.OneOk = true;
		}
		else if(col.tag == "SecondPart")
		{
			PuzzleTanvir.SecOk = true;
		}
		refTPuzzleSystem.GetComponent<PuzzleTanvir>().PullTrigger(col);
	}
}
