using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PersoSelection : MonoBehaviour 
{

	public Image[] Image = new Image[6];
	public GameObject RadialMenu;

	private float vertical;
	private float horizontal;
	private float angles;
	private int numCell;
	private int numCellOld;
	

	void Start () 
	{
		vertical = Input.GetAxis("Vertical");
		horizontal = Input.GetAxis("Horizontal");	
		numCell = numCellOld = 0;
		RadialMenu.SetActive(false);	
	}
	
	
	void Update () 
	{
		vertical = Input.GetAxis("Vertical");
		horizontal = Input.GetAxis("Horizontal");
		angles = Mathf.Atan2(horizontal,vertical) * Mathf.Rad2Deg;

		if(Input.GetAxis("3Joystick") >= 0.5f)
		{
			RadialMenu.SetActive(true);
			if(angles >= 0.0f && angles < 60.0f)
				numCell = 0;
			if(angles >= 60.0f && angles < 120.0f)
				numCell = 1;
			if(angles >= 120.0f && angles < 180.0f)
				numCell = 2;
			if(angles >= 180.0f && angles < 240.0f)
				numCell = 3;
			if(360.0f + angles >= 240.0f && 360.0f +  angles < 300.0f)
				numCell = 4;
			if(360.0f + angles >= 300.0f && 360.0f +  angles < 360.0f)
				numCell = 5;

			if(numCell != numCellOld)
			{
				Image[numCellOld].color = Color.white;
				numCellOld = numCell;
			}
			Image[numCell].color = Color.red;
		}
		else
			RadialMenu.SetActive(false);
		
		
	}
}
